import 'package:flutter/material.dart';
import 'splash_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // --- GLOBAL VARIABLE UNTUK PERAN ---
  // false = Pekerja, true = Klien (Default false, nanti diubah di WelcomePage)
  static bool isClient = false; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner DEBUG
      title: 'LapoKerja',
      theme: ThemeData(
        primarySwatch: Colors.indigo, 
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Sans-serif', 
        useMaterial3: false, 
      ),
      // Titik awal aplikasi adalah Splash Screen
      home: const SplashScreen(),
    );
  }
}