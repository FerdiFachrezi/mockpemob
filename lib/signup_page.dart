import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Akses User
import 'components.dart';
import 'profile_setup_page.dart'; // Halaman tujuan setelah daftar
import 'main_nav.dart'; // Navigasi ke Home jika ternyata user lama login via Google
import 'main.dart'; // Akses MyApp.isClient
import 'services/auth_service.dart'; // Service Auth

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controller Input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false; // Untuk loading state

  // --- 1. LOGIKA PENDAFTARAN EMAIL (MANUAL) ---
  void _handleSignUp() async {
    // A. Validasi Input
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom wajib diisi!"))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // B. Buat Akun di Firebase Auth
      User? user = await AuthService().signUp(
        _emailController.text.trim(), 
        _passController.text.trim()
      );
      
      if (user != null) {
        // C. Update Display Name (Simpan Nama di Auth sementara)
        await user.updateDisplayName(_nameController.text.trim());
        await user.reload(); 

        if (!mounted) return;

        // D. Navigasi ke Setup Profil
        // Kita gunakan pushReplacement agar user tidak bisa back ke halaman daftar
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
        );
      }
    } catch (e) {
      // Error Handling (Email sudah ada, Password lemah, dll)
      String message = "Gagal mendaftar: ${e.toString()}";
      if (e.toString().contains("email-already-in-use")) {
        message = "Email sudah terdaftar. Silakan login.";
      } else if (e.toString().contains("weak-password")) {
        message = "Password terlalu lemah. Gunakan minimal 6 karakter.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(message))
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. LOGIKA PENDAFTARAN GOOGLE (TAP LOGIN) ---
  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    
    try {
      // Panggil fungsi Google Sign-In dari AuthService
      // Fungsi ini pintar: Auto Register jika user baru, Auto Login jika user lama
      final userModel = await AuthService().signInWithGoogle();

      if (!mounted) return;

      if (userModel != null) {
        // A. Update Role Global Aplikasi
        setState(() {
          MyApp.isClient = (userModel.role == 'client');
        });

        // B. Cek Kelengkapan Data
        // Jika User Baru (lokasi masih "-"), arahkan ke Setup Profil untuk melengkapi data
        if (userModel.location == "-" || userModel.location == null) {
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
          );
        } else {
          // Jika ternyata User Lama (data lengkap), langsung ke Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNav()),
          );
        }
      } 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Google Sign-Up Gagal: $e"))
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    "Buat akun",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                const InputLabel(label: "Nama Lengkap"),
                CustomTextField(
                  hintText: "Nama Anda",
                  controller: _nameController, 
                ),
                const SizedBox(height: 20),

                const InputLabel(label: "Email"),
                CustomTextField(
                  hintText: "email@contoh.com",
                  controller: _emailController, 
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
                const SizedBox(height: 40),

                // TOMBOL DAFTAR (EMAIL)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("DAFTAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ),
                ),
                
                const SizedBox(height: 15),

                // TOMBOL DAFTAR (GOOGLE)
                GoogleButton(
                  onPressed: _isLoading ? () {} : _handleGoogleLogin, // Terhubung ke fungsi Google
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Kamu sudah memiliki akun? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Kembali ke Login
                      },
                      child: const Text(
                        "Masuk",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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