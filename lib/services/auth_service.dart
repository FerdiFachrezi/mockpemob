import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart'; // Pastikan path ini benar sesuai folder Anda
import '../main.dart'; // Untuk akses MyApp.isClient

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Getter User saat ini (bawaan Firebase)
  User? get currentUser => _auth.currentUser;

  // --- 1. SIGN IN WITH GOOGLE (Mengembalikan UserModel) ---
  Future<UserModel?> signInWithGoogle() async {
    try {
      // A. Trigger Pop-up Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User membatalkan login

      // B. Ambil Detail Autentikasi
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // C. Buat Kredensial Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // D. Masuk ke Firebase
      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user!;

      // E. Cek apakah User sudah ada di Firestore?
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        // === USER BARU (Auto Register) ===
        String role = MyApp.isClient ? 'client' : 'worker';
        
        UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email!,
          name: user.displayName ?? "User Google",
          role: role,
          location: "-", // Belum diisi, nanti dicek di UI
          imageUrl: user.photoURL,
        );

        // Simpan ke Firestore
        await saveUserProfile(newUser);
        return newUser;
      } else {
        // === USER LAMA (Login Biasa) ===
        // Konversi data Firestore ke UserModel
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }

    } catch (e) {
      throw Exception("Google Sign-In Gagal: $e");
    }
  }

  // --- 2. LOGIN EMAIL (Mengembalikan UserModel) ---
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Ambil data detail dari Firestore
      DocumentSnapshot doc = await _firestore.collection('users').doc(result.user!.uid).get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null; // Login berhasil di Auth, tapi data profil tidak ada di DB
    } catch (e) {
      rethrow; // Lempar error ke UI (Password salah, dll)
    }
  }

  // --- 3. REGISTER EMAIL (Mengembalikan User Firebase biasa) ---
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  // --- 4. SIMPAN PROFIL ---
  Future<void> saveUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }
  
  // --- 5. LOGOUT ---
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Logout dari Google juga agar bisa ganti akun
    await _auth.signOut();
  }
}