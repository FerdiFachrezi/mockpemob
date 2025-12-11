import 'package:flutter/material.dart';
import 'components.dart';
import 'reviews_page.dart';
import 'booking_page.dart'; // Navigasi ke Form Pemesanan

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({super.key});

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- 1. KONTEN UTAMA (SCROLLABLE) ---
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Padding untuk Bottom Bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(context),
                _buildMainInfo(),
                const Divider(thickness: 8, color: Color(0xFFF5F5F5)), // Pemisah Tebal
                _buildDescriptionSection(),
                const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
                _buildStatsSection(),
                const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                _buildReviewPreview(context),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // --- 2. TOMBOL NAVIGASI ATAS (BACK & SHARE) ---
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIcon(Icons.arrow_back, onTap: () => Navigator.pop(context)),
                Row(
                  children: [
                    _buildCircleIcon(Icons.share_outlined, onTap: () {}),
                    const SizedBox(width: 10),
                    _buildCircleIcon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorited ? Colors.red : Colors.black,
                      onTap: () {
                        setState(() {
                          _isFavorited = !_isFavorited;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),

          // --- 3. BOTTOM ACTION BAR (CHAT & PESAN) ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: Row(
                children: [
                  // Tombol Chat
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: kPrimaryColor),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Fitur Chat akan segera hadir..."))
                        );
                      },
                    ),
                  ),
                  // Tombol Pesan Jasa
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigasi ke Booking Page
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const BookingPage())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Pesan Jasa",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildCircleIcon(IconData icon, {Color color = Colors.black, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 320,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/avatar_placeholder.png'), 
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "1/5 Foto",
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // UPDATE: Menambahkan Card Kategori Tarif (Profesional)
  Widget _buildMainInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Lala Jola",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kTextColor),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Asisten Rumah Tangga",
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: kPrimaryColor),
                        const SizedBox(width: 4),
                        Text("Medan Tembung", style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                        const SizedBox(width: 15),
                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                        const SizedBox(width: 15),
                        const Text("Online", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        SizedBox(width: 4),
                        Text("5.0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text("(120 Ulasan)", style: TextStyle(fontSize: 10, color: Colors.orange)),
                  ],
                ),
              )
            ],
          ),
          
          const SizedBox(height: 25),

          // --- KARTU KATEGORI TARIF ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kInputFillColor, // Warna abu terang
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(Icons.workspace_premium_outlined, color: kPrimaryColor, size: 24),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kategori Tarif", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 4),
                      Text("Profesional", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextColor)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300)
                  ),
                  child: const Text("Nego", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tentang Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kTextColor)),
          const SizedBox(height: 12),
          Text(
            "Halo Ayah & Bunda! Saya Lala, berpengalaman 3 tahun sebagai pengasuh anak dan ART. Saya orangnya sabar, bersih, dan sangat menyukai anak-anak. Bisa memasak makanan sederhana dan menemani anak belajar.",
            style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 14),
          ),
          const SizedBox(height: 25),
          const Text("Keahlian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextColor)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSkillChip("Masak Sehat"),
              _buildSkillChip("Bisa Mengendarai Motor"),
              _buildSkillChip("Sabar & Telaten"),
              _buildSkillChip("Pembersih"),
              _buildSkillChip("Pecinta Hewan"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("3 Tahun", "Pengalaman"),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildStatItem("45+", "Pesanan"),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildStatItem("1 Jam", "Respon"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kTextColor)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildReviewPreview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Ulasan Pengguna", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kTextColor)),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewsPage())),
                child: const Text("Lihat Semua", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Budi Santoso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("2 Hari yang lalu", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(5, (i) => const Icon(Icons.star, size: 14, color: Colors.orange)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Sangat puas dengan kinerjanya, rumah jadi bersih banget dan orangnya ramah.",
                  style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}