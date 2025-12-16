import 'package:flutter/material.dart';
import 'components.dart';
import 'signup_page.dart';
import 'main_nav.dart';
import 'main.dart'; // Akses MyApp.isClient
import 'services/auth_service.dart'; // Akses Service Login
import 'models/user_model.dart'; // PENTING: Import Model agar tipe data dikenali
import 'profile_setup_page.dart'; // Untuk redirect user Google baru

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller Input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false; 

  // --- 1. LOGIKA LOGIN EMAIL (MANUAL) ---
  void _handleLogin() async {
    // A. Validasi Input Kosong
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi"))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // B. Panggil Service (Eksplisit menggunakan UserModel)
      UserModel? userModel = await AuthService().signIn(
        _emailController.text.trim(), 
        _passController.text.trim()
      );

      if (!mounted) return;

      if (userModel != null) {
        // C. Update Peran Global Aplikasi
        setState(() {
          MyApp.isClient = (userModel.role == 'client');
        });

        // D. Masuk ke Halaman Utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNav()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login gagal. Data profil tidak ditemukan."))
        );
      }
    } catch (e) {
      // Error Handling
      String err = e.toString();
      if (err.contains("user-not-found")) err = "Email tidak terdaftar.";
      else if (err.contains("wrong-password")) err = "Password salah.";
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Gagal Masuk: $err"))
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. LOGIKA LOGIN GOOGLE (TAP LOGIN) ---
  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    
    try {
      // A. Panggil Service Google (Eksplisit menggunakan UserModel)
      UserModel? userModel = await AuthService().signInWithGoogle();

      if (!mounted) return;

      if (userModel != null) {
        // B. Update Peran Global
        setState(() {
          MyApp.isClient = (userModel.role == 'client');
        });

        // C. Cek Kelengkapan Data (Redirect Pintar)
        // Jika lokasi masih kosong atau "-", berarti User Baru -> ke Setup Profil
        if (userModel.location == "-" || userModel.location == null || userModel.location!.isEmpty) {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
          );
        } else {
          // Jika data lengkap -> ke Halaman Utama
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNav()),
          );
        }
      } 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())) // Tampilkan error asli jika ada
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Selamat Datang Kembali!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kTextColor),
                  ),
                ),
                const SizedBox(height: 40),
                
                const InputLabel(label: "Email"),
                CustomTextField(
                  hintText: "user@gmail.com", 
                  controller: _emailController
                ),
                const SizedBox(height: 20),

                const InputLabel(label: "Sandi"),
                CustomTextField(
                  hintText: "••••••••••••",
                  isPassword: true,
                  isVisible: _isPasswordVisible,
                  controller: _passController,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // TOMBOL MASUK (EMAIL)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("MASUK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ),
                ),
                const SizedBox(height: 15),

                // TOMBOL MASUK (GOOGLE)
                GoogleButton(
                  onPressed: _isLoading ? () {} : _handleGoogleLogin, // Panggil Fungsi Google
                ),

                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Kamu belum memiliki akun? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text("Daftar", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}