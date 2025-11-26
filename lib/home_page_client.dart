import 'package:flutter/material.dart';
import 'components.dart';
import 'category_page.dart';

class HomePageClient extends StatelessWidget {
  const HomePageClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Scroll lebih natural
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER (BIRU TUA) ---
            Container(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
              width: double.infinity,
              color: kPrimaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Halo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const Text("Lapo Kerja.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.black54),
                        SizedBox(width: 10),
                        Text("Cari Pekerja", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // --- KATEGORI LAYANAN ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSectionHeader(context, "Kategori Layanan", onTapLainnya: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const CategoryPage()));
                  }),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 15,
                    runSpacing: 20,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      _buildCategoryItem(Icons.cleaning_services, "Asisten Rumah\nTangga"),
                      _buildCategoryItem(Icons.construction, "Pertukangan &\nKonstruksi"),
                      _buildCategoryItem(Icons.edit_note, "Edukasi &\nAkademik"),
                      _buildCategoryItem(Icons.restaurant_menu, "Catering &\nAcara"),
                      _buildCategoryItem(Icons.spa, "Perawatan &\nLayanan Pribadi"),
                      _buildCategoryItem(Icons.camera_alt, "Multimedia"),
                      _buildCategoryItem(Icons.agriculture, "Pertanian &\nPeternakan"),
                      _buildCategoryItem(Icons.mic, "Seni &\nHiburan"),
                    ],
                  ),
                ],
              ),
            ),

            // --- LAYANAN POPULER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionHeader(context, "Layanan Populer"),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildServiceCard(
                    "Muhammad Rizki",
                    "Asisten Rumah Tangga",
                    "Spesialis : Ahli Bantu Rumah",
                    "Tarif : Profesional",
                    "Medan Tembung",
                    "5.0",
                    isCardType: true,
                  ),
                  const SizedBox(width: 15),
                  _buildServiceCard(
                    "Ganjar Pranowo",
                    "Edukasi & Akademik",
                    "Spesialis : Guru Les Privat",
                    "Tarif : Ekonomis",
                    "Medan Baru",
                    "4.8",
                    isCardType: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- PEKERJA POPULER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionHeader(context, "Pekerja Populer"),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildServiceCard(
                    "Luhut Prabowo",
                    "Pertukangan & Konstruksi",
                    "Spesialis : Tukang Bangunan",
                    "",
                    "",
                    "5.0",
                    isCardType: false,
                  ),
                  const SizedBox(width: 15),
                  _buildServiceCard(
                    "Dewi Wangsa",
                    "Seni & Hiburan",
                    "Spesialis : Master of Ceremony",
                    "",
                    "",
                    "5.0",
                    isCardType: false,
                  ),
                ],
              ),
            ),

            // Jarak bawah agar tidak tertutup Navbar
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSectionHeader(BuildContext context, String title,
      {VoidCallback? onTapLainnya}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        GestureDetector(
          onTap: onTapLainnya ?? () {},
          child: const Text("Lainnya",
              style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Icon(icon, color: kPrimaryColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600, height: 1.2)),
        ],
      ),
    );
  }

  // --- FIXED CARD BUILDER (ANTI OVERFLOW) ---
  Widget _buildServiceCard(
    String name,
    String role,
    String specialist,
    String tarif,
    String location,
    String rating, {
    required bool isCardType,
  }) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Header
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/avatar_placeholder.png'),
                    fit: BoxFit.cover,
                    opacity: 0.8,
                  ),
                ),
              ),
              if (isCardType)
                Positioned(
                  bottom: -20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(
                              'assets/images/avatar_placeholder.png')),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: isCardType ? 25 : 10),

          // Konten Teks
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                
                // Role
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 2),

                // Spesialis
                Text(
                  specialist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),

                // Tarif (Optional)
                if (tarif.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    tarif,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 9,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ],

                const SizedBox(height: 8),

                // Lokasi & Rating (Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Lokasi (Expanded agar tidak menabrak rating)
                    if (location.isNotEmpty)
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 9, color: Colors.black54),
                        ),
                      ),
                    
                    const SizedBox(width: 4), // Jarak aman

                    // Badge Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.lightBlue.shade50,
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              size: 10, color: Colors.blue),
                          const SizedBox(width: 2),
                          Text(
                            rating,
                            style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}