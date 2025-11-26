import 'package:flutter/material.dart';
import 'components.dart';
import 'signup_page.dart';
import 'main_nav.dart';
import 'main.dart'; // PENTING: Import main.dart untuk akses MyApp.isClient

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
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kTextColor),
                  ),
                ),
                const SizedBox(height: 40),
                
                const InputLabel(label: "Email"),
                const CustomTextField(hintText: "user@gmail.com"),
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
                const SizedBox(height: 20),

                // --- TAMBAHAN SWITCH MOCK ROLE ---
                // Switch ini hanya untuk simulasi development
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.3))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Masuk sebagai: ${MyApp.isClient ? 'KLIEN' : 'PEKERJA'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyApp.isClient ? Colors.orange : kPrimaryColor
                        ),
                      ),
                      Switch(
                        value: MyApp.isClient,
                        activeColor: Colors.orange,
                        onChanged: (value) {
                          setState(() {
                            MyApp.isClient = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // ------------------------------------

                PrimaryButton(
                  text: "MASUK",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNav()),
                    );
                  },
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