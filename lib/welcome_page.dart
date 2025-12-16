import 'package:flutter/material.dart';
import 'components.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'main.dart'; 

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isClientSelected = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- HEADER MELENGKUNG (Diperkecil) ---
          SizedBox(
            // UBAH DISINI: Kurangi dari 0.42 menjadi 0.35 (35% tinggi layar)
            height: size.height * 0.35, 
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.35,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(200, 40),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // UBAH DISINI: Perkecil logo container sedikit (130 -> 110)
                      width: 110,
                      height: 110,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/logo_lapokerja.png',
                        // Jika gambar gagal load, tampilkan icon backup
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.handyman_rounded, size: 50, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- KONTEN BODY (Dengan Scroll agar tidak Overflow) ---
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Bergabung sebagai\nKlien atau Pekerja",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Pilihan 1: KLIEN
                    _buildOptionCard(
                      title: "Saya Klien",
                      subtitle: "Mencari Bantuan Pekerjaan",
                      icon: Icons.person,
                      isSelected: _isClientSelected,
                      onTap: () => setState(() => _isClientSelected = true),
                    ),

                    const SizedBox(height: 15),

                    // Pilihan 2: PEKERJA
                    _buildOptionCard(
                      title: "Saya Pekerja",
                      subtitle: "Mencari Pekerjaan Favoritku",
                      icon: Icons.engineering,
                      isSelected: !_isClientSelected,
                      onTap: () => setState(() => _isClientSelected = false),
                    ),

                    const SizedBox(height: 30), // Jarak sebelum tombol

                    // Tombol BUAT AKUN
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          MyApp.isClient = _isClientSelected;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                        child: const Text(
                          "BUAT AKUN",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Link Masuk
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah Punya Akun? ", style: TextStyle(color: Colors.grey)),
                        GestureDetector(
                          onTap: () {
                            MyApp.isClient = _isClientSelected;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: const Text("Masuk", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), // Jarak aman bawah
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.transparent), // Border bersih
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: kPrimaryColor),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kTextColor)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? kPrimaryColor : Colors.grey, width: 2),
              ),
              child: isSelected
                  ? Center(child: Container(width: 14, height: 14, decoration: const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle)))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}