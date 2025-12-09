import 'package:flutter/material.dart';
import 'components.dart';
import 'search_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"icon": Icons.cleaning_services, "label": "Asisten Rumah Tangga"},
    {"icon": Icons.construction, "label": "Pertukangan & Konstruksi"},
    // ... tambahkan lainnya
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategori Layanan", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, leading: const BackButton(color: Colors.black)),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Navigasi ke Search Page dengan query otomatis sesuai kategori
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(initialQuery: categories[index]['label'])));
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(categories[index]['icon'], color: kPrimaryColor),
                  ),
                  const SizedBox(width: 15),
                  Expanded(child: Text(categories[index]['label'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}