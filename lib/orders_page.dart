import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Akses Database
import 'package:firebase_auth/firebase_auth.dart'; // Akses User ID
import 'components.dart';
import 'order_detail_page.dart';
import 'main.dart'; // Akses MyApp.isClient
import 'main_nav.dart'; // Navigasi

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
    // Judul Header berubah sesuai Role
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
                // Tombol Back ke Home
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNav(initialIndex: 0)),
                      (route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                      ]
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                  ),
                ),
                
                Expanded(
                  child: Center(
                    child: Text(
                      title, 
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Penyeimbang Layout
              ],
            ),
          ),
          
          // --- KONTEN HALAMAN ---
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Tab Bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade200)
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        border: Border.all(color: kPrimaryColor, width: 2) 
                      ),
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

                  // Tab Views dengan StreamBuilder
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrderList(filterStatus: null), // Semua
                        _buildOrderList(filterStatus: ["Menunggu"]), // Baru
                        _buildOrderList(filterStatus: ["Diproses", "Diterima", "Dalam Proses"]), // Aktif
                        _buildOrderList(filterStatus: ["Selesai", "Dibatalkan", "Ditolak"]), // Selesai
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

  // --- BUILDER LIST DARI FIRESTORE ---
  Widget _buildOrderList({List<String>? filterStatus}) {
    // 1. Tentukan Field Filter berdasarkan Role
    // Jika Client -> Cari berdasarkan 'clientId'
    // Jika Worker -> Cari berdasarkan 'workerId'
    String filterField = MyApp.isClient ? 'clientId' : 'workerId';

    // 2. Buat Query Dasar
    Query query = FirebaseFirestore.instance
        .collection('orders')
        .where(filterField, isEqualTo: _currentUid)
        .orderBy('createdAt', descending: true);

    // 3. Terapkan Filter Status jika ada
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

        // State: Error
        if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
        }

        // State: Data Kosong
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 15),
                const Text("Belum ada pesanan di sini", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // State: Ada Data
        var orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var data = orders[index].data() as Map<String, dynamic>;
            var docId = orders[index].id; // ID Dokumen untuk update status nanti
            return _buildOrderCard(data, docId);
          },
        );
      },
    );
  }

  // --- KARTU UI ITEM PESANAN ---
  Widget _buildOrderCard(Map<String, dynamic> item, String docId) {
    bool isClient = MyApp.isClient;
    String statusText = item['status'] ?? 'Menunggu';
    
    // Tentukan Warna Badge Status
    Color statusColor;
    Color badgeBgColor;
    switch (statusText) {
      case "Menunggu": 
        statusColor = Colors.orange; badgeBgColor = Colors.orange.shade50; break;
      case "Diproses": 
      case "Diterima":
      case "Dalam Proses":
        statusColor = Colors.blue; badgeBgColor = Colors.blue.shade50; break;
      case "Selesai": 
        statusColor = Colors.green; badgeBgColor = Colors.green.shade50; break;
      case "Dibatalkan": 
      case "Ditolak":
        statusColor = Colors.red; badgeBgColor = Colors.red.shade50; break;
      default: 
        statusColor = Colors.grey; badgeBgColor = Colors.grey.shade100;
    }

    // Nama & Role yang ditampilkan (Kebalikan dari user login)
    String displayName = isClient ? (item['workerName'] ?? "Pekerja") : (item['clientName'] ?? "Klien");
    String displayRole = isClient ? (item['workerRole'] ?? "Penyedia Jasa") : "Pemberi Kerja";
    String displayImage = isClient 
        ? (item['workerImage'] ?? 'assets/images/avatar_placeholder.png')
        : 'assets/images/avatar_placeholder.png'; // Client image placeholder

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu: Foto, Nama, Status
          Row(
            children: [
              CircleAvatar(
                radius: 22, 
                backgroundImage: AssetImage(displayImage) // Bisa diganti NetworkImage jika ada URL
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(displayRole, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  statusText, 
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)
                )
              )
            ],
          ),
          const SizedBox(height: 15),
          const Divider(thickness: 1, height: 1),
          const SizedBox(height: 15),
          
          // Body Kartu: Detail Layanan & Tanggal
          Text("Layanan: ${item['service'] ?? '-'}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[800])),
          const SizedBox(height: 4),
          Text(
            "${item['date']} • ${item['time']}", 
            style: const TextStyle(fontSize: 13, color: Colors.black87)
          ),
          const SizedBox(height: 4),
          Text(
            item['location'] ?? '',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.grey)
          ),
          const SizedBox(height: 15),

          // Footer: Tombol Detail
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // Navigasi ke DetailPage dengan membawa ID Dokumen Firestore
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => OrderDetailPage(status: statusText)
                     // Note: OrderDetailPage perlu diupdate untuk menerima orderId/data lengkap
                     // Agar bisa menampilkan data dinamis, tapi untuk sekarang kirim status dulu.
                   )
                 );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Lihat Detail", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12, color: kPrimaryColor)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}