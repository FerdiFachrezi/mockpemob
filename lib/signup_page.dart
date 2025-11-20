import 'package:flutter/material.dart';
import 'components.dart'; // Import komponen widget & warna
import 'profile_setup_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                const CustomTextField(hintText: "Lala Jola"),
                const SizedBox(height: 20),

                const InputLabel(label: "Email"),
                const CustomTextField(hintText: "lalajola123@gmail.com"),
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

                PrimaryButton(
  text: "DAFTAR",
  onPressed: () {
     // Navigasi ke Profile Setup Page
     Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
     );
  },
),
                const SizedBox(height: 15),

                GoogleButton(onPressed: () {}),

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