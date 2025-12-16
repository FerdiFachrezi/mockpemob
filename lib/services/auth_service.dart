import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Pastikan file models/user_model.dart juga sudah ada

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan User yang sedang login
  User? get currentUser => _auth.currentUser;

  // 1. REGISTER
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 2. LOGIN
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Ambil data role dari Firestore
      DocumentSnapshot doc = await _firestore.collection('users').doc(result.user!.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 3. SIMPAN PROFIL
  Future<void> saveUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }
  
  // 4. LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}