import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // --- TAMBAHAN VARIABEL MOCK ---
  // Ubah jadi 'true' untuk simulasi sebagai Klien, 'false' sebagai Pekerja.
  // Kita akan mengubahnya lewat Login Page nanti.
  static bool isClient = false; 
  // ------------------------------

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login UI',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Sans-serif',
      ),
      home: const LoginPage(),
    );
  }
}