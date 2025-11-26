import 'package:flutter/material.dart';
import 'components.dart';
import 'edit_profile_page.dart';
import 'reviews_page.dart';
import 'login_page.dart';
import 'main.dart'; // Import untuk akses MyApp.isClient

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Mock berbeda tergantung role
    final String roleText = MyApp.isClient ? "Klien" : "Pekerja";
    final String nameText = MyApp.isClient ? "Lapo Kerja" : "Lala Jola";
    final String emailText = MyApp.isClient ? "lapokerja123@gmail.com" : "lalajola123@gmail.com";
    final String locationText = MyApp.isClient ? "Jalan Dr. T. Mansur No.9" : "Medan Tembung";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER ---
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          // Ganti gambar jika Klien (opsional)
                          backgroundImage: AssetImage(MyApp.isClient ? 'assets/images/avatar_placeholder.png' : 'assets/images/avatar_placeholder.png'),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        nameText,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        roleText,
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // --- KARTU INFORMASI UTAMA ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Profil", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              children: [
                                Text("Edit Profil", style: TextStyle(color: Colors.white, fontSize: 12)),
                                SizedBox(width: 4),
                                Icon(Icons.edit, color: Colors.white, size: 12),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Informasi Dasar (Tampil untuk Klien & Pekerja)
                    _buildProfileItem("Nama Lengkap", nameText),
                    _buildProfileItem("Email", emailText),
                    _buildProfileItem("Lokasi", locationText),

                    // --- BAGIAN KHUSUS PEKERJA (Disembunyikan jika Klien) ---
                    if (!MyApp.isClient) ...[
                      _buildProfileItem("Layanan", "Asisten Rumah Tangga"),
                      _buildProfileItem("Spesialis", "Pengasuh Anak, Perawat lansia"),
                      _buildProfileItem("Tarif", "Profesional"),
                      
                      const Text("Keahlian", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildTag("Ramah"),
                          _buildTag("Disiplin"),
                          _buildTag("Berpengalaman"),
                        ],
                      ),
                    ],
                    // ---------------------------------------------------------
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- TOMBOL NAVIGASI BAWAH ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuButton(
                    icon: Icons.vpn_key_outlined,
                    text: "Ganti Password",
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  
                  // Tombol Ulasan (Hanya untuk Pekerja yang menerima ulasan)
                  if (!MyApp.isClient) ...[
                     _buildMenuButton(
                      icon: Icons.star_outline,
                      text: "Ulasan",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewsPage()));
                      },
                    ),
                    const SizedBox(height: 15),
                  ],

                  _buildMenuButton(
                    icon: Icons.logout,
                    text: "Keluar",
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: kPrimaryColor,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildMenuButton({required IconData icon, required String text, required VoidCallback onTap, Color? textColor, Color? iconColor}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? kPrimaryColor),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: textColor ?? Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}