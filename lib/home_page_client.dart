import 'package:flutter/material.dart';
import 'components.dart';
import 'category_page.dart';
import 'search_page.dart'; 
import 'profile_page.dart'; // Kita pakai ProfilePage sebagai Detail Pekerja

class HomePageClient extends StatelessWidget {
  const HomePageClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
              width: double.infinity,
              color: kPrimaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Halo", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text("Lapo Kerja.", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  // Search Bar Action
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.black54),
                          SizedBox(width: 10),
                          Text("Cari Pekerja...", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // KATEGORI
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSectionHeader(context, "Kategori Layanan", onTapLainnya: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryPage()));
                  }),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 20, 
                    runSpacing: 25,
                    alignment: WrapAlignment.center, 
                    children: [
                      _buildCategoryItem(context, Icons.cleaning_services, "Asisten Rumah\nTangga"),
                      _buildCategoryItem(context, Icons.construction, "Pertukangan &\nKonstruksi"),
                      _buildCategoryItem(context, Icons.edit_note, "Edukasi &\nAkademik"),
                      _buildCategoryItem(context, Icons.restaurant_menu, "Catering &\nAcara"),
                    ],
                  ),
                ],
              ),
            ),

            // LAYANAN POPULER
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
                  _buildServiceCard(context, "Muhammad Rizki", "Asisten Rumah Tangga", "Ahli Bantu Rumah", "Profesional", "Medan Tembung", "5.0", true),
                  const SizedBox(width: 15),
                  _buildServiceCard(context, "Ganjar Pranowo", "Edukasi & Akademik", "Guru Les Privat", "Ekonomis", "Medan Baru", "4.8", true),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // PEKERJA POPULER
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
                  _buildServiceCard(context, "Luhut Prabowo", "Pertukangan", "Tukang Bangunan", "", "", "5.0", false),
                  const SizedBox(width: 15),
                  _buildServiceCard(context, "Dewi Wangsa", "Seni & Hiburan", "MC Kondang", "", "", "5.0", false),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onTapLainnya}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), 
        GestureDetector(
          onTap: onTapLainnya ?? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryPage())), 
          child: const Text("Lainnya", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage(initialQuery: "Asisten")));
      },
      child: Column(
        children: [
          Container(
            width: 70, height: 70, 
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              border: Border.all(color: Colors.grey.shade100)
            ),
            child: Icon(icon, color: kPrimaryColor, size: 35),
          ),
          const SizedBox(height: 10),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String name, String role, String specialist, String tarif, String location, String rating, bool isCardType) {
    return GestureDetector(
      onTap: () {
         // Mengarahkan ke ProfilePage sebagai simulasi Detail Pekerja
         Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
      },
      child: Container(
        width: 240, 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      image: const DecorationImage(image: AssetImage('assets/images/avatar_placeholder.png'), fit: BoxFit.cover),
                    ),
                  ),
                  if (isCardType)
                    Positioned(
                      bottom: -20, left: 0, right: 0,
                      child: Center(
                        child: CircleAvatar(radius: 25, backgroundColor: Colors.white, child: CircleAvatar(radius: 22, backgroundImage: AssetImage('assets/images/avatar_placeholder.png'))),
                      ),
                    ),
                ],
              ),
              SizedBox(height: isCardType ? 30 : 15),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), 
                    Text(role, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                    const SizedBox(height: 5),
                    Text(specialist, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                     if (tarif.isNotEmpty) Text(tarif, style: const TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 10),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         if (location.isNotEmpty) Expanded(child: Text(location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey))),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                           decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                           child: Row(children: [const Icon(Icons.star, size: 12, color: Colors.blue), const SizedBox(width: 4), Text(rating, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue))]),
                         )
                      ],
                     )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}