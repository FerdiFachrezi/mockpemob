import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Akses Database
import 'components.dart';
import 'worker_profile_page.dart'; 
import 'main_nav.dart'; // Untuk navigasi kembali ke Home

class SearchPage extends StatefulWidget {
  final String? initialQuery;
  const SearchPage({super.key, this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  final FocusNode _searchFocus = FocusNode();

  // Tag Populer (Tetap Statis untuk saran cepat)
  final List<String> _popularTags = [
    "Asisten Rumah Tangga",
    "Tukang Ledeng",
    "Guru Les",
    "Supir",
    "Service AC",
    "Masak"
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER PENCARIAN ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  // Tombol Back
                  InkWell(
                    onTap: () {
                      // Kembali ke MainNav (Home Client)
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => const MainNav(initialIndex: 0)
                        ), 
                        (route) => false
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Kolom Input
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: kInputFillColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Cari layanan atau nama pekerja...",
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onChanged: (val) {
                          // Update UI saat mengetik untuk filter realtime
                          setState(() {}); 
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. KONTEN HASIL ---
            Expanded(
              // Jika kosong -> Tampilkan Tag Populer
              // Jika ada teks -> Cari di Firestore
              child: _searchController.text.isEmpty
                  ? _buildInitialState() 
                  : _buildLiveSearchResults(),  
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan Default (Saran Kategori)
  Widget _buildInitialState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Pencarian Populer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _popularTags.map((tag) => _buildTagChip(tag)).toList(),
          ),
        ],
      ),
    );
  }

  // --- LOGIKA PENCARIAN FIRESTORE (REAL-TIME) ---
  Widget _buildLiveSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      // 1. Ambil data dari koleksi 'users' dimana role = 'worker'
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'worker')
          .snapshots(),
      builder: (context, snapshot) {
        // State Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // State Error
        if (snapshot.hasError) {
          return const Center(child: Text("Terjadi kesalahan koneksi"));
        }

        // State Data Kosong di DB
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Belum ada pekerja terdaftar"));
        }

        // 2. Filter Data di Sisi Aplikasi (Client-side Filtering)
        // Firestore gratisan tidak mendukung pencarian teks sebagian (LIKE query),
        // jadi kita ambil semua pekerja lalu filter di sini.
        final keyword = _searchController.text.toLowerCase();
        
        final filteredDocs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          
          // Ambil field (Nama, Layanan, Lokasi) dan jadikan huruf kecil
          final name = (data['name'] ?? '').toString().toLowerCase();
          final service = (data['serviceCategory'] ?? '').toString().toLowerCase();
          final location = (data['location'] ?? '').toString().toLowerCase();

          // Cek apakah keyword cocok dengan salah satu field
          return name.contains(keyword) || service.contains(keyword) || location.contains(keyword);
        }).toList();

        // Jika hasil filter kosong
        if (filteredDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 10),
                Text("Tidak ditemukan: \"${_searchController.text}\"", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
        }

        // 3. Tampilkan Hasil List
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: filteredDocs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            // Ambil data dan tambahkan UID dokumen
            final data = filteredDocs[index].data() as Map<String, dynamic>;
            data['uid'] = filteredDocs[index].id; 
            
            return _buildWorkerCard(data);
          },
        );
      },
    );
  }
  
  // Widget Chip Tag
  Widget _buildTagChip(String label) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(label, style: const TextStyle(color: Colors.black87, fontSize: 13)),
      ),
    );
  }

  // Widget Kartu Pekerja
  Widget _buildWorkerCard(Map<String, dynamic> data) {
    // Handling Nilai Null (Safety)
    String name = data['name'] ?? 'Tanpa Nama';
    String role = data['serviceCategory'] ?? 'Pekerja Umum';
    String rating = (data['rating'] ?? 0.0).toString();
    String location = data['location'] ?? '-';
    String? imageUrl = data['imageUrl']; // Bisa null

    return GestureDetector(
      onTap: () {
        // Navigasi ke Halaman Profil Pekerja dengan membawa Data Real
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => WorkerProfilePage(workerData: data) // Kirim map data ke profil
          )
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Profil
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
                image: DecorationImage(
                  image: (imageUrl != null && imageUrl.isNotEmpty)
                      ? NetworkImage(imageUrl) 
                      : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),
            
            // Detail Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 14),
                          const SizedBox(width: 4),
                          Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey))
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}