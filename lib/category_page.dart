import 'package:flutter/material.dart';
import 'components.dart';
import 'search_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  // Daftar lengkap 8 Kategori
  final List<Map<String, dynamic>> categories = const [
    {"icon": Icons.cleaning_services_outlined, "label": "Asisten Rumah Tangga"},
    {"icon": Icons.handyman_outlined, "label": "Pertukangan & Konstruksi"},
    {"icon": Icons.edit_note_outlined, "label": "Edukasi & Akademik"},
    {"icon": Icons.soup_kitchen_outlined, "label": "Catering & Acara"},
    {"icon": Icons.spa_outlined, "label": "Perawatan & Layanan Pribadi"},
    {"icon": Icons.camera_alt_outlined, "label": "Multimedia"},
    {"icon": Icons.agriculture_outlined, "label": "Pertanian & Peternakan"},
    {"icon": Icons.mic_none_outlined, "label": "Seni & Hiburan"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Background sedikit abu terang agar konsisten
      appBar: AppBar(
        title: const Text("Kategori Layanan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Navigasi ke Search Page dengan query otomatis sesuai kategori
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => SearchPage(initialQuery: categories[index]['label'])
                )
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05), 
                    blurRadius: 10,
                    offset: const Offset(0, 4)
                  )
                ],
              ),
              child: Row(
                children: [
                  // Icon Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.08), 
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Icon(categories[index]['icon'], color: kPrimaryColor, size: 24),
                  ),
                  const SizedBox(width: 15),
                  // Label Text
                  Expanded(
                    child: Text(
                      categories[index]['label'], 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)
                    )
                  ),
                  // Arrow Icon
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}