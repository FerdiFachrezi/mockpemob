import 'package:flutter/material.dart';
import 'components.dart';
import 'main.dart';
import 'home_page_client.dart';
// import 'orders_page.dart'; <--- HAPUS BARIS INI (Penyebab Unused Import)
import 'order_detail_page.dart'; 
import 'main_nav.dart'; // Pastikan ini ada agar MainNav.navKey dikenal

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (MyApp.isClient) {
      return const HomePageClient();
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
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("Hallo Lala Jola!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),

            // --- KONTEN ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Rangkuman Aktivitas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryCard("Pesanan Aktif", "2"),
                      _buildSummaryCard("Selesai", "5"),
                      _buildSummaryCard("Penilaian", "5.0"),
                    ],
                  ),
                  const SizedBox(height: 25),

                  const Text("Pesanan Aktif", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  
                  _buildActiveOrderCard(
                    context,
                    clientName: "Lapo Kerja",
                    address: "Jalan Dr. T. Mansur No.9 Medan Baru",
                    service: "Asisten Rumah Tangga",
                    type: "Pengasuh Anak",
                    date: "6 Okt 2025",
                    package: "Harian",
                    imgAsset: 'assets/images/avatar_placeholder.png',
                    status: "Diproses"
                  ),
                  _buildActiveOrderCard(
                    context,
                    clientName: "Samosir Helpet",
                    address: "Jalan Asia No. 180, Sei Rengas II",
                    service: "Asisten Rumah Tangga",
                    type: "Pengasuh lansia",
                    date: "12 Okt 2025",
                    package: "Harian",
                    imgAsset: 'assets/images/avatar_placeholder.png',
                    status: "Diproses"
                  ),

                  const SizedBox(height: 25),

                  const Text("Riwayat Singkat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _buildHistoryCard(context, "Hobas - Pengasuh Anak", "27 September 2025", "5.0"),
                  _buildHistoryCard(context, "Panbes - Pengasuh Anak", "27 September 2025", "5.0"),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildActiveOrderCard(BuildContext context, {required String clientName, required String address, required String service, required String type, required String date, required String package, required String imgAsset, required String status}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [CircleAvatar(radius: 20, backgroundImage: AssetImage(imgAsset)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Klien : $clientName", style: const TextStyle(fontWeight: FontWeight.bold)), Text(address, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.grey))]))]),
          const Divider(height: 20, thickness: 1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildInfoRow("Layanan", service), const SizedBox(height: 5), _buildInfoRow("Tipe Layanan", type)])),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildInfoRow("Tanggal Layanan", date),
                const SizedBox(height: 5),
                _buildInfoRow("Paket Layanan", package),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Masuk ke Detail Pesanan (Navbar Hilang Wajar)
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(status: status)));
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

  Widget _buildInfoRow(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)), Text(value, style: const TextStyle(fontSize: 11, color: Colors.grey))]);
  }

  Widget _buildHistoryCard(BuildContext context, String title, String date, String rating) {
    return GestureDetector(
      onTap: () {
        // Pindah Tab Navbar ke 'Orders' (Index 2)
        // Pastikan MainNav sudah di-update dengan navKey
        MainNav.navKey.currentState?.jumpToTab(2); 
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
        child: Row(children: [
          Container(width: 45, height: 45, decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11))])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Row(children: [Icon(Icons.check_circle, color: Colors.green, size: 14), SizedBox(width: 4), Text("Selesai", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold))]), const SizedBox(height: 5), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.lightBlue.shade50, borderRadius: BorderRadius.circular(8)), child: Row(children: [const Icon(Icons.star_border, size: 12, color: Colors.black), const SizedBox(width: 2), Text(rating, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]))])
        ]),
      ),
    );
  }
}