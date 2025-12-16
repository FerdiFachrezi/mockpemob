import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Jangan lupa: flutter pub add intl
import 'components.dart'; 

class ReviewsPage extends StatelessWidget {
  // Data pekerja yang ulasannya ingin ditampilkan
  final Map<String, dynamic> workerData;

  const ReviewsPage({
    super.key, 
    required this.workerData
  });

  @override
  Widget build(BuildContext context) {
    String workerId = workerData['uid'];
    String name = workerData['name'] ?? "Pekerja";
    String role = workerData['serviceCategory'] ?? "Penyedia Jasa";
    String? imageUrl = workerData['imageUrl'];
    double rating = (workerData['rating'] ?? 0.0).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))]),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      "Ulasan & Penilaian",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // --- KARTU INFO PEKERJA ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                                ? NetworkImage(imageUrl) as ImageProvider
                                : const AssetImage('assets/images/avatar_placeholder.png'),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(role, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- SKOR RATING TOTAL ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
                      child: Column(
                        children: [
                          Text(
                            "${rating.toStringAsFixed(1)}/5.0",
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -1),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.star, 
                                color: index < rating.round() ? kPrimaryColor : Colors.grey.shade300, 
                                size: 32
                              ),
                            )),
                          ),
                          const SizedBox(height: 10),
                          const Text("Total Kepuasan Klien", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- LIST ULASAN (REAL-TIME FIRESTORE) ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Riwayat Ulasan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    const SizedBox(height: 15),

                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('reviews')
                          .where('workerId', isEqualTo: workerId)
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                        }
                        if (snapshot.hasError) {
                          return const Text("Gagal memuat data (Cek Index Firestore)");
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(child: Text("Belum ada ulasan.", style: TextStyle(color: Colors.grey))),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            return _buildReviewCard(data);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> data) {
    String dateStr = "";
    if (data['createdAt'] != null) {
      DateTime dt = (data['createdAt'] as Timestamp).toDate();
      dateStr = DateFormat('dd MMM yyyy').format(dt);
    }
    String responseSpeed = data['responseSpeed'] ?? "";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: (data['clientImage'] != null) 
                    ? NetworkImage(data['clientImage']) 
                    : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['clientName'] ?? "Pengguna", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(dateStr, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  int r = (data['rating'] ?? 0).toInt();
                  return Icon(Icons.star, size: 16, color: i < r ? kPrimaryColor : Colors.grey[300]);
                }),
              ),
            ],
          ),
          
          if (responseSpeed.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text("Respon: $responseSpeed", style: const TextStyle(fontSize: 10, color: kPrimaryColor, fontWeight: FontWeight.bold)),
              ),
            ),

          const SizedBox(height: 12),
          Text(data['comment'] ?? "", style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }
}