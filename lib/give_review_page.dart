import 'package:flutter/material.dart';
import 'components.dart'; // Memerlukan kPrimaryColor

class GiveReviewPage extends StatefulWidget {
  const GiveReviewPage({super.key});

  @override
  State<GiveReviewPage> createState() => _GiveReviewPageState();
}

class _GiveReviewPageState extends State<GiveReviewPage> {
  // State untuk menyimpan rating yang dipilih (0-5)
  int _selectedRating = 0;
  // Controller untuk input komentar
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Style dekorasi kartu putih yang berulang
    final BoxDecoration cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
        )
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Warna background sesuai desain
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER ---
            _buildHeader(context),

            // --- 2. KONTEN SCROLLABLE ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    // Kartu Info Pekerja
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: cardDecoration,
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
                              SizedBox(height: 4),
                              Text("Asisten Rumah Tangga", style: TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Kartu Rating Bintang
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      width: double.infinity,
                      decoration: cardDecoration,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Menghasilkan 5 bintang interaktif
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedRating = index + 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Icon(
                                    // Ubah ikon berdasarkan rating yang dipilih
                                    index < _selectedRating ? Icons.star : Icons.star_border_purple500_outlined,
                                    color: index < _selectedRating ? kPrimaryColor : Colors.grey.shade400, // Warna bintang aktif/inaktif
                                    size: 40,
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 15),
                          const Text("Beri Penilaian Anda", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Kartu Input Komentar
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tambahkan Komentar (Opsional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _commentController,
                            maxLines: 5, // Area teks yang cukup tinggi
                            decoration: const InputDecoration(
                              hintText: "Berikan Komentar Anda disini",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                              border: InputBorder.none, // Menghilangkan garis border default
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 3. TOMBOL KIRIM (Footer) ---
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Validasi sederhana: Pastikan bintang sudah dipilih
                  if (_selectedRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mohon berikan penilaian bintang terlebih dahulu."))
                    );
                    return;
                  }
                  
                  // TODO: Logika kirim ulasan ke backend di sini
                  
                  // Tutup halaman dan beri feedback
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Terima kasih! Ulasan Anda telah dikirim."))
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor, // Warna biru tua
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  "Kirim Ulasan",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Header Kustom sesuai desain
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Tombol Kembali (Kiri)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                  ),
                ),
              ),
              // Judul Tengah
              const Text("Beri Ulasan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          // Sub-judul
          const Text(
            "Ulasan Anda membantu kami menjaga kualitas layanan",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}