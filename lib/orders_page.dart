import 'package:flutter/material.dart';
import 'components.dart'; // Mengambil kPrimaryColor dari sini
import 'order_detail_page.dart';
import 'main.dart'; 

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor, // Ganti background scaffold agar senada saat bounce scroll
      body: Column(
        children: [
          // --- HEADER ---
          Container(
            color: kPrimaryColor, // <--- UBAH DISINI (Sebelumnya 0xFF333333)
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
            width: double.infinity,
            child: Row(
              children: [
                // Tombol Back (Opsional)
                // Jika ingin disembunyikan karena ini halaman utama nav, bungkus dengan Visibility(visible: false, ...)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      MyApp.isClient ? "Riwayat Pesanan" : "Daftar Pekerjaan",
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 30), // Dummy spacer penyeimbang
              ],
            ),
          ),
          
          // --- TAB BAR & LIST ---
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Judul Sub
                  const Text("Lihat semua pesanan yang telah kamu buat.", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  
                  // Tab Bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300)
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
                        Tab(text: "Diproses"),
                        Tab(text: "Selesai"),
                        Tab(text: "Dibatalkan"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Isi Tab (List Pesanan)
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrderList(), 
                        _buildOrderList(filter: "Diproses"), 
                        _buildOrderList(filter: "Selesai"), 
                        _buildOrderList(filter: "Dibatalkan"), 
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList({String? filter}) {
    // Mock Data
    List<Map<String, dynamic>> orders = [
      {
        "name": "Lala Jola",
        "role": "Asisten Rumah Tangga",
        "service": "Pengasuh Anak",
        "date": "6 Okt 2025",
        "status": "Selesai"
      },
      {
        "name": "Putri Wulandari",
        "role": "Asisten Rumah Tangga",
        "service": "Perawat Lansia",
        "date": "8 Okt 2025",
        "status": "Diproses"
      },
      {
        "name": "Muhammad Rizki",
        "role": "Asisten Rumah Tangga",
        "service": "Ahli Beres Rumah",
        "date": "10 Okt 2025",
        "status": "Dibatalkan"
      },
    ];

    if (filter != null) {
      orders = orders.where((o) => o['status'] == filter).toList();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final item = orders[index];
        return _buildOrderCard(item);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> item) {
    Color statusColor;
    IconData statusIcon;

    switch (item['status']) {
      case "Selesai":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case "Diproses":
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_filled;
        break;
      case "Dibatalkan":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(item['role'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(width: 4),
                  Text(item['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              )
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoCol("Tipe Layanan", item['service']),
              _buildInfoCol("Paket Layanan", "Harian"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoCol("Tanggal Pemesanan", item['date']),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(status: item['status'])));
                },
                child: const Text("Lihat Detail >", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}