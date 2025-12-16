import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Wajib import ini
import 'splash_screen.dart'; 

void main() async { // Tambah async
  WidgetsFlutterBinding.ensureInitialized(); // Wajib
  await Firebase.initializeApp(); // Wajib untuk Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // --- GLOBAL VARIABLE UNTUK PERAN ---
  static bool isClient = false; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LapoKerja',
      theme: ThemeData(
        primarySwatch: Colors.indigo, 
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Sans-serif', 
        useMaterial3: false, 
      ),
      home: const SplashScreen(),
    );
  }
}