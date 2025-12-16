import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:intl/intl.dart'; 
import 'components.dart';
import 'booking_page.dart';
import 'reviews_page.dart'; 

class WorkerProfilePage extends StatefulWidget {
  final Map<String, dynamic> workerData;

  const WorkerProfilePage({
    super.key, 
    required this.workerData 
  });

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.workerData['uid']) 
          .snapshots(),
      builder: (context, snapshot) {
        Map<String, dynamic> data = widget.workerData; 

        if (snapshot.hasData && snapshot.data!.exists) {
          data = snapshot.data!.data() as Map<String, dynamic>;
          data['uid'] = widget.workerData['uid']; 
        }

        // --- AMBIL DATA DENGAN NULL SAFETY ---
        String name = data['name'] ?? 'Tanpa Nama';
        String role = data['serviceCategory'] ?? 'Penyedia Jasa';
        String location = data['location'] ?? '-';
        String? imageUrl = data['imageUrl']; 
        String bio = data['bio'] ?? 'Belum ada deskripsi profil.';
        String skills = data['skills'] ?? ''; 
        
        // [FIX] Ambil Tarif dari Database sesuai nama field di screenshot (rateCategory)
        // Jika kosong, tampilkan '-'
        String rateCategory = data['rateCategory'] ?? '-';

        double rating = (data['rating'] ?? 0.0).toDouble();
        int reviewCount = (data['reviewCount'] ?? 0).toInt();
        String responseSpeed = data['avgResponseSpeed'] ?? "Cepat";

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderImage(imageUrl),
                    
                    // [FIX] Kirim parameter rateCategory ke fungsi _buildMainInfo
                    _buildMainInfo(name, role, location, rating, reviewCount, rateCategory),
                    
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildDescriptionSection(bio, skills),
                    const Divider(thickness: 1, height: 1, color: Color(0xFFEEEEEE)),
                    _buildStatsSection(reviewCount, responseSpeed),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildRealtimeReviews(context, data),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Tombol Back & Favorite
              Positioned(
                top: 40, left: 20, right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleIcon(Icons.arrow_back, onTap: () => Navigator.pop(context)),
                    Row(
                      children: [
                        _buildCircleIcon(Icons.share_outlined, onTap: () {}),
                        const SizedBox(width: 10),
                        _buildCircleIcon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorited ? Colors.red : Colors.black,
                          onTap: () => setState(() => _isFavorited = !_isFavorited),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // Bottom Bar (Chat & Pesan)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(12)),
                        child: IconButton(
                          icon: const Icon(Icons.chat_bubble_outline, color: kPrimaryColor),
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Chat segera hadir..."))),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => BookingPage(
                                  workerId: data['uid'],
                                  workerName: name,
                                  workerRole: role,
                                  workerImage: imageUrl,
                                )
                              )
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text("Pesan Jasa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildStatsSection(int orderCount, String responseSpeed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("$orderCount+", "Pesanan"),
          Container(width: 1, height: 40, color: Colors.grey.shade300),
          _buildStatItem(responseSpeed, "Respon"),
        ],
      ),
    );
  }

  Widget _buildRealtimeReviews(BuildContext context, Map<String, dynamic> workerFullData) {
    String workerId = workerFullData['uid'];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Ulasan Pengguna", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kTextColor)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ReviewsPage(workerData: workerFullData) 
                    )
                  );
                },
                child: const Text("Lihat Semua", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reviews')
                .where('workerId', isEqualTo: workerId)
                .orderBy('createdAt', descending: true)
                .limit(3) 
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                    child: Text("Belum ada ulasan.", style: TextStyle(color: Colors.grey)),
                  ),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildReviewItem(data);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> data) {
    String dateStr = "";
    if (data['createdAt'] != null) {
      DateTime dt = (data['createdAt'] as Timestamp).toDate();
      dateStr = DateFormat('dd MMM yyyy').format(dt);
    }
    String responseSpeed = data['responseSpeed'] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['clientName'] ?? "Pengguna", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(dateStr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      int rating = (data['rating'] ?? 0).toInt();
                      return Icon(Icons.star, size: 14, color: i < rating ? Colors.orange : Colors.grey[300]);
                    }),
                  ),
                  if (responseSpeed.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text("Respon: $responseSpeed", style: const TextStyle(fontSize: 10, color: kPrimaryColor, fontWeight: FontWeight.bold)),
                    )
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(data['comment'] ?? "", style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildCircleIcon(IconData icon, {Color color = Colors.black, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _buildHeaderImage(String? imageUrl) {
    return Stack(
      children: [
        Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            image: DecorationImage(
              image: (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl) as ImageProvider
                  : const AssetImage('assets/images/avatar_placeholder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(height: 30, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30)))),
        ),
      ],
    );
  }

  // [FIX] Menggunakan parameter 'rateCategory' untuk ditampilkan
  Widget _buildMainInfo(String name, String role, String location, double rating, int reviewCount, String rateCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kTextColor)),
                    const SizedBox(height: 5),
                    Text(role, style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: kPrimaryColor),
                        const SizedBox(width: 4),
                        Expanded(child: Text(location, style: TextStyle(color: Colors.grey[700], fontSize: 13), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 4),
                        Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text("($reviewCount Ulasan)", style: const TextStyle(fontSize: 10, color: Colors.orange)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: kInputFillColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)), child: const Icon(Icons.workspace_premium_outlined, color: kPrimaryColor, size: 24)),
                const SizedBox(width: 15),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Kategori Tarif", style: TextStyle(color: Colors.grey, fontSize: 12)), SizedBox(height: 4), Text("Profesional", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextColor))])),
                
                // [FIX] Menampilkan Data Asli rateCategory (Tarif) dari DB
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), 
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)), 
                  child: Text(
                    rateCategory, // <-- Tampilkan data asli di sini (bukan 'Nego' atau 'Standar' manual)
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)
                  )
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(String bio, String skillsString) {
    List<String> skills = skillsString.split(',').where((s) => s.trim().isNotEmpty).toList();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tentang Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kTextColor)),
          const SizedBox(height: 12),
          Text(bio, style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 14)),
          const SizedBox(height: 25),
          if (skills.isNotEmpty) ...[
            const Text("Keahlian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextColor)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: skills.map((skill) => _buildSkillChip(skill.trim())).toList())
          ]
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(children: [Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kTextColor)), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]);
  }
}