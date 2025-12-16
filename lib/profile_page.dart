import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components.dart';
import 'login_page.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart'; 
import 'edit_profile_page.dart'; 
import 'reviews_page.dart'; 
import 'change_password_page.dart'; // [BARU] Import ChangePasswordPage

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginPage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || !snapshot.data!.exists) return const Center(child: Text("Profil tidak ditemukan"));

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          UserModel userModel = UserModel.fromMap(data);
          
          bool isClient = (userModel.role == 'client');

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context, userModel, isClient),
                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Header & Tombol Edit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Informasi Pribadi", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage())),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(20)),
                              child: const Row(children: [Text("Edit Profil", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)), SizedBox(width: 6), Icon(Icons.edit, color: Colors.white, size: 12)]),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Detail Card
                      _buildDetailCard(children: [
                        _buildProfileItem("Nama Lengkap", userModel.name),
                        _buildProfileItem("Email", userModel.email),
                        _buildProfileItem("Lokasi", userModel.location ?? '-'),
                        
                        // BAGIAN KHUSUS PEKERJA
                        if (!isClient) ...[
                          const Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: Divider()),
                          _buildProfileItem("Layanan", userModel.serviceCategory ?? '-'),
                          _buildProfileItem("Tarif", userModel.rateCategory ?? '-'),
                          
                          // Tombol Lihat Ulasan Saya
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => ReviewsPage(workerData: userModel.toMap())
                                  )
                                );
                              },
                              icon: const Icon(Icons.star_outline, size: 18, color: kPrimaryColor),
                              label: const Text("Lihat Ulasan Saya", style: TextStyle(color: kPrimaryColor)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kPrimaryColor),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12)
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          const Text("Keahlian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8, runSpacing: 8,
                            children: (userModel.skills ?? '-').split(',').map((skill) => _buildChip(skill.trim())).toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                          const SizedBox(height: 5),
                          Text(userModel.bio ?? '-', style: const TextStyle(fontSize: 14, height: 1.5)),
                        ]
                      ]),

                      const SizedBox(height: 25),

                      // [TOMBOL GANTI PASSWORD] (Untuk Klien & Pekerja)
                      ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.lock_outline, color: Colors.orange),
                        ),
                        title: const Text("Ganti Password", style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ),

                      const Divider(),

                      // TOMBOL KELUAR
                      ListTile(
                        onTap: () async {
                          await AuthService().signOut();
                          if(context.mounted) {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.logout, color: Colors.red),
                        ),
                        title: const Text("Keluar Akun", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ),
                      
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET HELPERS ---
  Widget _buildHeader(BuildContext context, UserModel user, bool isClient) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(screenWidth, 60)), boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Column(
        children: [
          const Text("Profil Saya", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 55, backgroundColor: Colors.white,
              backgroundImage: (user.imageUrl != null && user.imageUrl!.isNotEmpty) ? NetworkImage(user.imageUrl!) as ImageProvider : const AssetImage('assets/images/avatar_placeholder.png'),
            ),
          ),
          const SizedBox(height: 15),
          Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          Text(isClient ? "Klien" : "Pekerja", style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required List<Widget> children}) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children));
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500))]));
  }

  Widget _buildChip(String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: kPrimaryColor.withOpacity(0.2))), child: Text(label, style: const TextStyle(color: kPrimaryColor, fontSize: 11, fontWeight: FontWeight.bold)));
  }
}