import 'package:flutter/material.dart';
import 'components.dart';
import 'signup_page.dart';
import 'main_nav.dart';
import 'main.dart'; // Penting: Akses MyApp.isClient
import 'services/auth_service.dart'; // Penting: Akses Logic Login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false; 

  // --- LOGIKA LOGIN ---
  void _handleLogin() async {
    // 1. Validasi Input Kosong
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi"))
      );
      return;
    }

    setState(() => _isLoading = true); // Mulai Loading

    try {
      // 2. Panggil Service Login
      final userModel = await AuthService().signIn(
        _emailController.text.trim(), 
        _passController.text.trim()
      );

      if (!mounted) return; // Cek jika widget masih aktif

      if (userModel != null) {
        // 3. SUKSES: Update Role Aplikasi
        // Jika role di database == 'client', set MyApp.isClient = true
        // Jika role == 'worker', set MyApp.isClient = false
        setState(() {
          MyApp.isClient = (userModel.role == 'client');
        });

        // 4. Navigasi ke Halaman Utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNav(initialIndex: 0)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data profil tidak ditemukan."))
        );
      }
    } catch (e) {
      // 5. GAGAL (Password Salah / User Tidak Ada)
      String errorMessage = "Login Gagal. Periksa email & password Anda.";
      if (e.toString().contains("user-not-found")) {
        errorMessage = "Email tidak terdaftar.";
      } else if (e.toString().contains("wrong-password")) {
        errorMessage = "Password salah.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(errorMessage))
      );
    } finally {
      if (mounted) setState(() => _isLoading = false); // Stop Loading
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

                // Tombol LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin, // Panggil fungsi di sini
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

                GoogleButton(onPressed: () {}),

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