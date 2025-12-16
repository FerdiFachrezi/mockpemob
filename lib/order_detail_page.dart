import 'package:flutter/material.dart';
import 'components.dart';
import 'edit_order_page.dart';
import 'worker_profile_page.dart'; 
import 'give_review_page.dart'; // [BARU] Import halaman Beri Ulasan
import 'main.dart'; 

class OrderDetailPage extends StatelessWidget {
  final String status;
  const OrderDetailPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    bool isClient = MyApp.isClient;
    // Deteksi jika ini adalah tawaran pekerjaan baru bagi pekerja
    bool isJobOffer = !isClient && status == "Menunggu";

    Color statusColor;
    IconData statusIcon;
    if (status == "Selesai") { 
      statusColor = Colors.green; 
      statusIcon = Icons.check_circle; 
    } else if (status == "Diproses" || status == "Menunggu") { 
      statusColor = Colors.orange; 
      statusIcon = Icons.access_time_filled; 
    } else { 
      statusColor = Colors.red; 
      statusIcon = Icons.cancel; 
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
                            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
                          ),
                        ),
                        Text(isJobOffer ? "Detail Pekerjaan" : "Detail Pesanan", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                        const SizedBox(width: 40), 
                      ],
                    ),
                    const SizedBox(height: 25),

                    // KARTU UTAMA
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(radius: 25, backgroundImage: AssetImage('assets/images/avatar_placeholder.png')),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(isClient ? "Lala Jola" : "Klien : Lapo Kerja", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    if (isClient) ...[const Text("Asisten Rumah Tangga", style: TextStyle(fontSize: 11, color: Colors.grey)), const Text("Profesional", style: TextStyle(fontSize: 11, color: Colors.orange))]
                                  ],
                                ),
                              ),
                              // Badge status disembunyikan jika sedang mode Job Offer
                              if (!isJobOffer)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Row(children: [Icon(statusIcon, color: statusColor, size: 14), const SizedBox(width: 4), Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11))]),
                                )
                            ],
                          ),
                          const Divider(height: 30),
                          _buildDetailRow("Layanan", "Asisten Rumah Tangga"),
                          _buildDetailRow("Paket Layanan", "Harian"),
                          _buildDetailRow("Tanggal Layanan", "6 Okt 2025"),
                          _buildDetailRow("Waktu Kerja", "08:00 - 16:00"),
                          _buildDetailRow("Lokasi Pekerjaan", "Jalan Dr. T. Mansur No.9 Medan Baru"),
                          _buildDetailRow("Catatan Tambahan", "Tolong ini itu jangan ini itu nanti ini itu......."),
                          _buildDetailRow("Metode Pembayaran", "Bayar Tunai di tempat"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // MENU AKSI
                    if (isClient) ...[
                      // Navigasi ke Detail Pekerja
                      _buildActionTile(Icons.person_outline, "Profile Pekerja", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkerProfilePage()))),
                      const SizedBox(height: 10),
                    ],
                    
                    _buildActionTile(Icons.phone_outlined, isClient ? "Hubungi Pekerja" : "Hubungi Client", subtitle: "Anda bisa berdiskusi terkait detail pekerjaan lebih detail disini.", onTap: () {}),
                    
                    if (isClient) ...[
                      const SizedBox(height: 10),
                      // [BARU] Navigasi ke Halaman Beri Ulasan
                      _buildActionTile(
                        Icons.rate_review_outlined, 
                        "Beri Ulasan ke Pekerja", 
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GiveReviewPage()))
                      ),
                    ],
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ),

            // --- BOTTOM BUTTONS ---
            
            // 1. KLIEN: Edit / Batal (Jika Diproses)
            if (isClient && status == "Diproses")
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
                child: Row(
                  children: [
                    Expanded(child: ElevatedButton(onPressed: () => _showCancelModal(context), style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Batalkan Pesanan", style: TextStyle(color: Colors.white)))),
                    const SizedBox(width: 15),
                    Expanded(child: OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditOrderPage())), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), side: const BorderSide(color: kPrimaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("Edit Pesanan", style: TextStyle(color: kPrimaryColor)))),
                  ],
                ),
              ),

            // 2. PEKERJA: Tolak / Terima (Jika Menunggu / Job Offer)
            if (isJobOffer)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context), 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor, 
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: const Text("Tolak Pekerjaan", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: kPrimaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: const Text("Terima Pekerjaan", style: TextStyle(color: kPrimaryColor)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helpers
  Widget _buildDetailRow(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey))]));
  }

  Widget _buildActionTile(IconData icon, String title, {String? subtitle, VoidCallback? onTap}) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 3)]), child: Row(children: [Icon(icon, color: kPrimaryColor), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey))])), const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)])));
  }

  void _showCancelModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Batalkan Pesanan"),
        content: const Text("Apakah Anda yakin ingin membatalkan pesanan ini?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tidak")),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Ya, Batalkan", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}