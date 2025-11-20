// File: lib/login_page.dart

import 'package:flutter/material.dart';
import 'components.dart';   
import 'signup_page.dart';  
import 'profile_page.dart'; // <--- IMPORT BARU (Pastikan ini ada)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

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
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                const InputLabel(label: "Email"),
                const CustomTextField(
                  hintText: "lalajola123@gmail.com",
                ),
                const SizedBox(height: 20),

                const InputLabel(label: "Sandi"),
                CustomTextField(
                  hintText: "••••••••••••",
                  isPassword: true,
                  isVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // --- UPDATE DI SINI ---
                PrimaryButton(
                  text: "MASUK",
                  onPressed: () {
                    // Navigasi sementara ke ProfilePage
                    // Menggunakan pushReplacement agar user tidak bisa kembali ke Login dengan tombol Back
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                ),
                // ---------------------
                
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