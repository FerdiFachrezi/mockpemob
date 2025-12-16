import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components.dart';
import 'category_page.dart';
import 'search_page.dart'; 
import 'worker_profile_page.dart'; 

class HomePageClient extends StatelessWidget {
  const HomePageClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HEADER ---
            Container(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 25),
              width: double.infinity,
              color: kPrimaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Lapo Kerja.",
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  
                  // Search Bar
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, size: 28, color: Colors.black87),
                          SizedBox(width: 12),
                          Text(
                            "Cari Pekerja",
                            style: TextStyle(color: Colors.black54, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // --- 2. KATEGORI LAYANAN ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSectionHeader(context, "Kategori Layanan", onTapLainnya: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryPage()));
                  }),
                  const SizedBox(height: 15),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double itemWidth = (constraints.maxWidth - 45) / 4; 
                      return Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        alignment: WrapAlignment.start,
                        children: [
                          _buildCategoryItem(context, Icons.cleaning_services_outlined, "Asisten Rumah\nTangga", itemWidth),
                          _buildCategoryItem(context, Icons.handyman_outlined, "Pertukangan &\nKonstruksi", itemWidth),
                          _buildCategoryItem(context, Icons.edit_note_outlined, "Edukasi &\nAkademik", itemWidth),
                          _buildCategoryItem(context, Icons.soup_kitchen_outlined, "Catering &\nAcara", itemWidth),
                          _buildCategoryItem(context, Icons.spa_outlined, "Perawatan &\nLayanan Pribadi", itemWidth),
                          _buildCategoryItem(context, Icons.camera_alt_outlined, "Multimedia", itemWidth),
                          _buildCategoryItem(context, Icons.agriculture_outlined, "Pertanian &\nPeternakan", itemWidth),
                          _buildCategoryItem(context, Icons.mic_external_on_outlined, "Seni &\nHiburan", itemWidth),
                        ],
                      );
                    }
                  ),
                ],
              ),
            ),

            // --- 3. LAYANAN POPULER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionHeader(
                context, 
                "Layanan Populer",
                onTapLainnya: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage(initialQuery: "")))
              ), 
            ),
            const SizedBox(height: 15),
            
            // [FIX] Mengubah tinggi dari 185 menjadi 220 agar tidak overflow
            SizedBox(
              height: 220, 
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'worker')
                    .orderBy('reviewCount', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Belum ada data populer.", style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Tambah padding vertikal sedikit
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      data['uid'] = doc.id; 

                      return _buildServiceCard(context, data);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // --- 4. PEKERJA FAVORIT ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSectionHeader(
                context, 
                "Pekerja Favorit",
                onTapLainnya: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage(initialQuery: "")))
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              height: 220,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'worker')
                    .orderBy('rating', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Belum ada pekerja.", style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      data['uid'] = doc.id;

                      return _buildWorkerCard(context, data);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 40), 
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onTapLainnya}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)), 
        GestureDetector(
          onTap: onTapLainnya ?? () {}, 
          child: const Text("Lainnya", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, IconData icon, String label, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(initialQuery: label.replaceAll("\n", " "))));
      },
      child: Column(
        children: [
          Container(
            width: width, height: width, 
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              border: Border.all(color: Colors.grey.shade100)
            ),
            child: Icon(icon, color: kPrimaryColor, size: 32),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: width + 10,
            child: Text(
              label, 
              textAlign: TextAlign.center, 
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Card Layanan Populer (Yang diperbaiki)
  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> data) {
    String name = data['name'] ?? 'Tanpa Nama';
    String role = data['serviceCategory'] ?? 'Umum';
    String location = data['location'] ?? '-';
    String rating = (data['rating'] ?? 0.0).toStringAsFixed(1);
    String? imageUrl = data['imageUrl'];
    String skills = data['skills'] ?? ''; 
    String specialist = skills.split(',').firstOrNull ?? role;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => WorkerProfilePage(workerData: data)
        ));
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, 
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: (imageUrl != null && imageUrl.isNotEmpty) 
                          ? NetworkImage(imageUrl) as ImageProvider
                          : const AssetImage('assets/images/avatar_placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: (imageUrl != null && imageUrl.isNotEmpty) 
                          ? NetworkImage(imageUrl) as ImageProvider
                          : const AssetImage('assets/images/avatar_placeholder.png'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25), 
            
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
                  const SizedBox(height: 2),
                  Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black54), textAlign: TextAlign.center),
                  const SizedBox(height: 2),
                  Text(specialist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
                  
                  const SizedBox(height: 8),
                  const Divider(height: 1, thickness: 0.5),
                  const SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 10, color: Colors.grey),
                            const SizedBox(width: 2),
                            Expanded(child: Text(location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.black87))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.lightBlue.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 10, color: Colors.blue),
                            const SizedBox(width: 2),
                            Text(rating, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
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
      ),
    );
  }

  // Card Pekerja Favorit
  Widget _buildWorkerCard(BuildContext context, Map<String, dynamic> data) {
    String name = data['name'] ?? 'Tanpa Nama';
    String role = data['serviceCategory'] ?? 'Umum';
    String rating = (data['rating'] ?? 0.0).toStringAsFixed(1);
    String? imageUrl = data['imageUrl'];
    String skills = data['skills'] ?? '';
    String specialist = skills.split(',').firstOrNull ?? role;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => WorkerProfilePage(workerData: data)
        ));
      },
      child: Container(
        width: 160,
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
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: (imageUrl != null && imageUrl.isNotEmpty) 
                          ? NetworkImage(imageUrl) as ImageProvider
                          : const AssetImage('assets/images/avatar_placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [const Icon(Icons.star, size: 10, color: kPrimaryColor), const SizedBox(width: 2), Text(rating, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: kPrimaryColor))]),
                  ),
                )
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
                  const SizedBox(height: 2),
                  Text(specialist, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}