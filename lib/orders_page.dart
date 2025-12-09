import 'package:flutter/material.dart';
import 'components.dart';
import 'order_detail_page.dart';
import 'main.dart'; 
import 'main_nav.dart'; // Import MainNav

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                // [PERBAIKAN] Tombol Back yang Pasti Berfungsi
                GestureDetector(
                  // Membuat area sentuh lebih responsif
                  behavior: HitTestBehavior.opaque, 
                  onTap: () {
                    // Logika: Hapus semua tumpukan halaman dan mulai ulang dari MainNav (Home)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNav()),
                      (route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10), // Padding sedikit diperbesar agar mudah diklik
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
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                ),
                
                // Penyeimbang layout agar judul tetap di tengah
                const SizedBox(width: 40), 
              ],
            ),
          ),
          
          // --- KONTEN HALAMAN (Sama seperti sebelumnya) ---
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

                  // Tab Views
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildList("Semua"),
                        _buildList("Baru"),
                        _buildList("Aktif"),
                        _buildList("Selesai"),
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

  // --- WIDGET HELPER (TIDAK ADA PERUBAHAN) ---
  Widget _buildList(String tabName) {
    bool isClient = MyApp.isClient;
    
    // MOCK DATA
    final List<Map<String, dynamic>> allOrders = [
      {"name": isClient ? "Ibu Siti" : "Lala Jola", "role": "Asisten Rumah Tangga", "detail": "Membersihkan rumah 2 lantai, cuci piring.", "status": "Menunggu", "date": "12 Okt 2025"},
      {"name": isClient ? "Budi Santoso" : "Pak Ahmad", "role": "Pertukangan", "detail": "Memperbaiki atap bocor di garasi.", "status": "Menunggu", "date": "13 Okt 2025"},
      {"name": isClient ? "Samosir Helpet" : "Ibu Rina", "role": "Pengasuh Lansia", "detail": "Menjaga nenek usia 80 tahun.", "status": "Diproses", "date": "10 Okt 2025"},
      {"name": isClient ? "Ratna Juwita" : "Kak Sari", "role": "Pengasuh Anak", "detail": "Menjaga balita seharian.", "status": "Selesai", "date": "6 Okt 2025"},
      {"name": isClient ? "Muhammad Rizki" : "Pak Joko", "role": "Ahli Beres Rumah", "detail": "Pindahan rumah.", "status": "Dibatalkan", "date": "1 Okt 2025"},
    ];

    List<Map<String, dynamic>> filteredOrders = [];
    if (tabName == "Semua") filteredOrders = allOrders;
    else if (tabName == "Baru") filteredOrders = allOrders.where((o) => o['status'] == "Menunggu").toList();
    else if (tabName == "Aktif") filteredOrders = allOrders.where((o) => o['status'] == "Diproses").toList();
    else if (tabName == "Selesai") filteredOrders = allOrders.where((o) => o['status'] == "Selesai" || o['status'] == "Dibatalkan").toList();

    if (filteredOrders.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.folder_open, size: 50, color: Colors.grey[300]), const SizedBox(height: 10), const Text("Belum ada pesanan di sini", style: TextStyle(color: Colors.grey))]));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(filteredOrders[index], isClient);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> item, bool isClient) {
    Color statusColor;
    Color badgeBgColor;
    String statusText = item['status'];

    switch (statusText) {
      case "Menunggu": statusColor = Colors.orange; badgeBgColor = Colors.orange.shade50; break;
      case "Diproses": statusColor = Colors.orange; badgeBgColor = Colors.orange.shade50; break;
      case "Selesai": statusColor = Colors.green; badgeBgColor = Colors.green.shade50; break;
      case "Dibatalkan": statusColor = Colors.red; badgeBgColor = Colors.red.shade50; break;
      default: statusColor = Colors.grey; badgeBgColor = Colors.grey.shade100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 22, backgroundImage: AssetImage('assets/images/avatar_placeholder.png')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isClient ? "Pekerja: ${item['name']}" : "Klien: ${item['name']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(item['role'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)), child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)))
            ],
          ),
          const SizedBox(height: 15),
          const Divider(thickness: 1, height: 1),
          const SizedBox(height: 15),
          Text("Detail Pekerjaan:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey[800])),
          const SizedBox(height: 4),
          Text(item['detail'], style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(status: statusText)));
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