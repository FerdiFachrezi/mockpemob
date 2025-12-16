import 'package:flutter/material.dart';
import 'components.dart';
import 'login_page.dart';
import 'reviews_page.dart';
import 'edit_profile_page.dart';
import 'main.dart'; // Import untuk cek MyApp.isClient

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cek Role
    final bool isClient = MyApp.isClient;
    
    // Mengambil lebar layar untuk membuat lengkungan yang responsif
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background abu muda
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(), 
        child: Column(
          children: [
            // --- HEADER (Biru Melengkung) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              decoration: BoxDecoration(
                color: kPrimaryColor, // Warna Biru Tua
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(screenWidth, 60),
                ),
                boxShadow: [
                   BoxShadow(
                     color: kPrimaryColor.withOpacity(0.3),
                     blurRadius: 20,
                     offset: const Offset(0, 10),
                   )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Profil Saya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Avatar Foto
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 15),

                  // Nama & Role
                  Text(
                    isClient ? "Lapo Kerja" : "Lala Jola",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isClient ? "Klien" : "Pekerja",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- KONTEN MENU (Area Putih) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Header "Informasi Pribadi" & Tombol Edit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Informasi Pribadi", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      
                      // TOMBOL EDIT PROFIL (Sekarang Muncul untuk Klien & Pekerja)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            children: [
                              Text("Edit Profil", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                              SizedBox(width: 6),
                              Icon(Icons.edit, color: Colors.white, size: 12)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Kartu Detail Profil
                  _buildDetailCard(children: [
                    _buildProfileItem("Nama Lengkap", isClient ? "Lapo Kerja" : "Lala Jola"),
                    _buildProfileItem("Email", isClient ? "lapokerja@gmail.com" : "lalajola123@gmail.com"),
                    _buildProfileItem("Lokasi", isClient ? "Jalan Dr. T. Mansur No.9" : "Medan Tembung"),
                    
                    // --- BAGIAN INI HANYA UNTUK PEKERJA ---
                    if (!isClient) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(),
                      ),
                      _buildProfileItem("Layanan", "Asisten Rumah Tangga"),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Spesialis", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 4),
                            const Text("Pengasuh Anak, Perawat lansia", style: TextStyle(fontSize: 14, color: Colors.black87)),
                          ],
                        ),
                      ),
                      _buildProfileItem("Tarif", "Profesional"),
                      
                      const SizedBox(height: 10),
                      const Text("Keahlian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildChip("Ramah"),
                          _buildChip("Disiplin"),
                          _buildChip("Berpengalaman"),
                        ],
                      )
                    ]
                  ]),

                  const SizedBox(height: 25),

                  // Tombol Ganti Password (UNTUK SEMUA)
                  GestureDetector(
                    onTap: () => _showChangePasswordModal(context),
                    child: _buildMenuButton(Icons.vpn_key_outlined, "Ganti Password"),
                  ),

                  const SizedBox(height: 15),

                  // Tombol Ulasan (HANYA UNTUK PEKERJA)
                  if (!isClient)
                    GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewsPage()));
                      },
                      child: _buildMenuButton(Icons.star_outline, "Ulasan"),
                    ),
                  
                  if (!isClient) const SizedBox(height: 40) else const SizedBox(height: 20),
                  
                  // Tombol Keluar (UNTUK SEMUA)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => const LoginPage()), 
                          (route) => false
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.red.withOpacity(0.08),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                      ),
                      child: const Text("Keluar Akun", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildDetailCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: kPrimaryColor, size: 22),
          ),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  // --- MODAL GANTI PASSWORD ---
  void _showChangePasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              const Text("Ganti Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Masukkan Password Lama dan Password Baru Anda.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 25),
              _buildPasswordField("Password Lama"),
              const SizedBox(height: 15),
              _buildPasswordField("Password Baru"),
              const SizedBox(height: 15),
              _buildPasswordField("Konfirmasi Password Baru"),
              const SizedBox(height: 30),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context), 
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                      side: const BorderSide(color: kPrimaryColor)
                    ), 
                    child: const Text("Batal", style: TextStyle(color: kPrimaryColor))
                  )
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () { 
                      Navigator.pop(context); 
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password berhasil diubah!"))); 
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor, 
                      padding: const EdgeInsets.symmetric(vertical: 15), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                    ), 
                    child: const Text("Konfirmasi", style: TextStyle(color: Colors.white, fontSize: 14))
                  )
                ),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPasswordField(String hint) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: kPrimaryColor)),
      ),
    );
  }
}