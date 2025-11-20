import 'package:flutter/material.dart';
import 'components.dart';   // Widget & Warna Custom
import 'signup_page.dart';  // Halaman Daftar
import 'main_nav.dart';     // <--- TUJUAN BARU (Halaman Utama dengan Navigasi Bawah)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  // Controller (Opsional, disiapkan jika nanti butuh ambil data input)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                // Header Judul
                const Center(
                  child: Text(
                    "Selamat Datang Kembali!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Input Email
                const InputLabel(label: "Email"),
                CustomTextField(
                  hintText: "lalajola123@gmail.com",
                  controller: _emailController,
                ),
                const SizedBox(height: 20),

                // Input Sandi
                const InputLabel(label: "Sandi"),
                CustomTextField(
                  hintText: "••••••••••••",
                  isPassword: true,
                  isVisible: _isPasswordVisible,
                  controller: _passwordController,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // Tombol Masuk
                PrimaryButton(
                  text: "MASUK",
                  onPressed: () {
                    // Navigasi ke Halaman Utama (Home)
                    // Menggunakan pushReplacement agar user tidak bisa menekan tombol 'Back' kembali ke Login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNav()),
                    );
                  },
                ),
                const SizedBox(height: 15),

                // Tombol Google
                GoogleButton(onPressed: () {}),

                const SizedBox(height: 20),
                
                // Footer Text (Link ke Daftar)
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
                      child: const Text(
                        "Daftar",
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