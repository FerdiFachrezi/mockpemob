import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'components.dart';
import 'order_detail_page.dart';
import 'main.dart'; 
import 'main_nav.dart'; 

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = MyApp.isClient ? "Riwayat Pesanan" : "Daftar Pekerjaan Masuk";

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          // --- HEADER ---
          Container(
            color: kPrimaryColor,
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
            width: double.infinity,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainNav(initialIndex: 0)),
                    (route) => false,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                  ),
                ),
                Expanded(child: Center(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))),
                const SizedBox(width: 40),
              ],
            ),
          ),
          
          // --- KONTEN ---
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFF8F9FA), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // TAB BAR
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade200)),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white, border: Border.all(color: kPrimaryColor, width: 2)),
                      labelColor: kPrimaryColor,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: "Semua"),
                        Tab(text: "Baru"),
                        Tab(text: "Aktif"),
                        Tab(text: "Selesai"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TAB VIEW
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrderList(filterStatus: null),
                        _buildOrderList(filterStatus: ["Menunggu"]),
                        _buildOrderList(filterStatus: ["Diproses", "Diterima", "Dalam Proses"]),
                        _buildOrderList(filterStatus: ["Selesai", "Dibatalkan", "Ditolak"]),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderList({List<String>? filterStatus}) {
    String filterField = MyApp.isClient ? 'clientId' : 'workerId';

    Query query = FirebaseFirestore.instance
        .collection('orders')
        .where(filterField, isEqualTo: _currentUid)
        .orderBy('createdAt', descending: true);

    if (filterStatus != null) {
      query = query.where('status', whereIn: filterStatus);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        // State: Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // State: Error (Tampilan User Friendly)
        if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan memuat data.\nSilakan coba lagi nanti.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])));
        }

        // State: Data Kosong
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 15),
                const Text("Tidak ada pesanan di sini", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                  MyApp.isClient ? "Mulai cari pekerja untuk membantu Anda" : "Tunggu pesanan masuk dari klien",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        }

        var orders = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var data = orders[index].data() as Map<String, dynamic>;
            var docId = orders[index].id; 
            return _buildOrderCard(data, docId);
          },
        );
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> item, String docId) {
    bool isClient = MyApp.isClient;
    String statusText = item['status'] ?? 'Menunggu';
    
    Color statusColor;
    Color badgeBgColor;
    switch (statusText) {
      case "Menunggu": statusColor = Colors.orange; badgeBgColor = Colors.orange.shade50; break;
      case "Diproses": 
      case "Diterima": 
      case "Dalam Proses": statusColor = Colors.blue; badgeBgColor = Colors.blue.shade50; break;
      case "Selesai": statusColor = Colors.green; badgeBgColor = Colors.green.shade50; break;
      case "Dibatalkan": 
      case "Ditolak": statusColor = Colors.red; badgeBgColor = Colors.red.shade50; break;
      default: statusColor = Colors.grey; badgeBgColor = Colors.grey.shade100;
    }

    String displayName = isClient ? (item['workerName'] ?? "Pekerja") : (item['clientName'] ?? "Klien");
    String displayRole = isClient ? (item['workerRole'] ?? "Penyedia Jasa") : "Pemberi Kerja";
    String displayImage = isClient ? (item['workerImage'] ?? 'assets/images/avatar_placeholder.png') : 'assets/images/avatar_placeholder.png';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 22, backgroundImage: AssetImage(displayImage)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text(displayRole, style: const TextStyle(fontSize: 12, color: Colors.grey))]),
              ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)), child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)))
            ],
          ),
          const SizedBox(height: 15),
          const Divider(thickness: 1, height: 1),
          const SizedBox(height: 15),
          Text("Layanan: ${item['service'] ?? '-'}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[800])),
          const SizedBox(height: 4),
          Text("${item['date']} • ${item['time']}", style: const TextStyle(fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(item['location'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => OrderDetailPage(
                      orderId: docId, 
                      orderData: item
                    )
                  )
                );
              },
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Text("Lihat Detail", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 13)), SizedBox(width: 4), Icon(Icons.arrow_forward_ios, size: 12, color: kPrimaryColor)]),
            ),
          )
        ],
      ),
    );
  }
}