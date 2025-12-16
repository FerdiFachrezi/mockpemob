import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components.dart';
import 'main.dart';
import 'home_page_client.dart';
import 'order_detail_page.dart'; 
import 'main_nav.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    // 1. Jika User adalah Client, alihkan ke HomePageClient
    if (MyApp.isClient) {
      return const HomePageClient();
    }

    // 2. StreamBuilder Utama: Mengambil Data Profil Pekerja (Nama, Rating)
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(_currentUid).snapshots(),
      builder: (context, userSnapshot) {
        // Default Data jika loading/null
        String userName = "Pekerja";
        String rating = "0.0";
        String? userImage;

        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          userName = userData['name'] ?? "Pekerja";
          rating = (userData['rating'] ?? 0.0).toStringAsFixed(1);
          userImage = userData['imageUrl'];
        }

        // 3. StreamBuilder Kedua: Mengambil Data Pesanan (Orders)
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('workerId', isEqualTo: _currentUid)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, orderSnapshot) {
            
            // Hitung Ringkasan Data
            int activeCount = 0;
            int finishedCount = 0;
            List<DocumentSnapshot> activeOrders = [];
            List<DocumentSnapshot> historyOrders = [];

            if (orderSnapshot.hasData) {
              final docs = orderSnapshot.data!.docs;
              for (var doc in docs) {
                final status = (doc.data() as Map<String, dynamic>)['status'] ?? '';
                
                // Logic Filter Status
                if (['Menunggu', 'Diproses', 'Diterima', 'Dalam Proses'].contains(status)) {
                  activeCount++;
                  activeOrders.add(doc);
                } else if (status == 'Selesai') {
                  finishedCount++;
                  // Ambil maksimal 2 untuk riwayat singkat di Home
                  if (historyOrders.length < 2) {
                    historyOrders.add(doc);
                  }
                }
              }
            }

            return Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 60, bottom: 30),
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: (userImage != null && userImage.isNotEmpty)
                                  ? NetworkImage(userImage) as ImageProvider
                                  : const AssetImage('assets/images/avatar_placeholder.png'),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text("Halo, $userName!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ),

                    // --- KONTEN DASHBOARD ---
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Rangkuman Aktivitas
                          const Text("Rangkuman Aktivitas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSummaryCard("Pesanan Aktif", "$activeCount"),
                              _buildSummaryCard("Selesai", "$finishedCount"),
                              _buildSummaryCard("Penilaian", rating),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // 2. Pesanan Aktif (Real-time List)
                          const Text("Pesanan Aktif", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 10),
                          
                          if (activeOrders.isEmpty)
                            _buildEmptyState("Belum ada pesanan aktif saat ini.")
                          else
                            ...activeOrders.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return _buildActiveOrderCard(context, data, doc.id);
                            }),

                          const SizedBox(height: 25),

                          // 3. Riwayat Singkat
                          const Text("Riwayat Singkat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 10),
                          
                          if (historyOrders.isEmpty)
                            _buildEmptyState("Belum ada riwayat pesanan selesai.")
                          else
                            ...historyOrders.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return _buildHistoryCard(context, data);
                            }),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSummaryCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
        child: Column(
          children: [
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrderCard(BuildContext context, Map<String, dynamic> data, String docId) {
    String clientName = data['clientName'] ?? 'Klien';
    String address = data['location'] ?? '-';
    String service = data['service'] ?? '-';
    String date = data['date'] ?? '-';
    String status = data['status'] ?? 'Menunggu';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/images/avatar_placeholder.png')), // Client Image placeholder
            const SizedBox(width: 12), 
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Klien : $clientName", style: const TextStyle(fontWeight: FontWeight.bold)), 
              Text(address, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.grey))
            ]))
          ]),
          const Divider(height: 20, thickness: 1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildInfoRow("Layanan", service), 
                const SizedBox(height: 5), 
                _buildInfoRow("Status", status)
              ])),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildInfoRow("Tanggal", date),
                const SizedBox(height: 5),
                _buildInfoRow("Jam", data['time'] ?? '-'),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    // Navigasi ke DetailPage dengan Data Real
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(
                          orderId: docId, 
                          orderData: data
                        )
                      )
                    );
                  },
                  child: const Text("Lihat Detail >", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> data) {
    String clientName = data['clientName'] ?? 'Klien';
    String date = data['date'] ?? '-';
    
    return GestureDetector(
      onTap: () {
        // Pindah Tab Navbar ke 'Orders' (Index 1 untuk Pekerja)
        final navState = MainNav.navKey.currentState;
        if (navState != null) {
          navState.jumpToTab(1);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
        child: Row(children: [
          Container(
            width: 45, height: 45, 
            decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle),
            child: const Icon(Icons.history, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(clientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), 
            Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11))
          ])),
          const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(children: [
              Icon(Icons.check_circle, color: Colors.green, size: 14), 
              SizedBox(width: 4), 
              Text("Selesai", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold))
            ]),
          ])
        ]),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)), 
      Text(value, style: const TextStyle(fontSize: 11, color: Colors.grey))
    ]);
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200)
      ),
      child: Center(
        child: Text(message, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }
}