import 'dart:async';
import 'package:flutter/material.dart';
import 'components.dart'; // Untuk akses warna kPrimaryColor
import 'welcome_page.dart'; // Tujuan navigasi setelah splash screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer: Menunggu 3 detik, lalu pindah ke WelcomePage
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna utama aplikasi sebagai background
      backgroundColor: kPrimaryColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- LOGO APLIKASI ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Image.asset(
                'assets/images/logo_lapokerja.png', // Pastikan nama file ini benar
                width: 100, 
                height: 100,
                // Icon cadangan jika gambar belum ada
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.handyman_rounded, 
                  size: 60, 
                  color: kPrimaryColor
                ),
              ),
            ),
            
            const SizedBox(height: 25),
            
            // --- TEKS JUDUL (Opsional, jika logo sudah ada teks bisa dihapus) ---
            const Text(
              "LapoKerja",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                fontFamily: 'Sans-serif',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Solusi Pekerjaan Harian Anda",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}