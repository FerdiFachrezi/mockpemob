import 'package:flutter/material.dart';
import 'components.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"icon": Icons.cleaning_services, "label": "Asisten Rumah Tangga"},
    {"icon": Icons.construction, "label": "Pertukangan & Konstruksi"},
    {"icon": Icons.edit_note, "label": "Edukasi & Akademik"},
    {"icon": Icons.restaurant_menu, "label": "Catering & Acara"},
    {"icon": Icons.spa, "label": "Perawatan & Layanan Pribadi"},
    {"icon": Icons.camera_alt, "label": "Multimedia"},
    {"icon": Icons.agriculture, "label": "Pertanian & Peternakan"},
    {"icon": Icons.mic, "label": "Seni & Hiburan"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Kategori Layanan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const Divider(height: 30),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){},
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0,2))],
                    border: Border.all(color: Colors.grey.shade100)
                  ),
                  child: Icon(categories[index]['icon'], color: kPrimaryColor),
                ),
                const SizedBox(width: 15),
                Expanded(child: Text(categories[index]['label'], style: const TextStyle(fontWeight: FontWeight.w500))),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }
}