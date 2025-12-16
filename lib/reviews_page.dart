import 'package:flutter/material.dart';
import 'components.dart'; // Menggunakan kPrimaryColor untuk warna bintang & teks

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- MOCK DATA ULASAN ---
    // Disesuaikan agar mirip dengan referensi
    final List<Map<String, dynamic>> reviews = [
      {
        "name": "Lapo Kerja",
        "role": "Pengasuh Anak",
        "rating": 5,
        "comment": "Pesan Ulasan.........",
        // Di aplikasi nyata, ini bisa url gambar user lain
      },
      {
        "name": "Budi Santoso",
        "role": "Klien",
        "rating": 5,
        "comment": "Pekerjaan sangat rapi dan cepat. Sangat direkomendasikan!",
      },
      {
        "name": "Siti Aminah",
        "role": "Klien",
        "rating": 4,
        "comment": "Datang tepat waktu dan sangat profesional.",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Background hampir putih
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // --- HEADER CUSTOM ---
              Row(
                children: [
                  // Tombol Back (Lingkaran Putih)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Judul
                  const Expanded(
                    child: Text(
                      "Ulasan Klien Tentang Anda",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                "Ulasan Anda membantu kami menjaga kualitas layanan",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 25),

              // --- KARTU 1: PROFIL PENGGUNA (Lala Jola) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                    ),
                    const SizedBox(width: 15),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Lala Jola", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 2),
                        Text("Asisten Rumah Tangga", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // --- KARTU 2: SKOR RATING TOTAL ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "5.0/5.0",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Bintang Besar (Warna Biru Tua / Ungu sesuai gambar)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.star, color: kPrimaryColor, size: 32),
                      )),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // --- LIST ULASAN (LOOPING) ---
              // Menampilkan item review seperti kartu ke-3 di gambar
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final item = reviews[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Reviewer
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              // Menggunakan placeholder, di real app bisa pakai item['image']
                              backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text(item['role'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Bintang Kecil
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              Icons.star,
                              size: 16,
                              // Logic warna bintang (penuh/kosong)
                              color: starIndex < item['rating'] ? kPrimaryColor : Colors.grey[300],
                            );
                          }),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Isi Komentar
                        Text(
                          item['comment'],
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}