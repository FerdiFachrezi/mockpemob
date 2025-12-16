import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components.dart';
import 'worker_profile_page.dart'; // Import ini sekarang AKAN TERPAKAI
import 'give_review_page.dart';
import 'main.dart'; 

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderDetailPage({
    super.key, 
    required this.orderId, 
    required this.orderData
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _isLoading = false;

  // Fungsi Update Status (Terima/Tolak/Selesai/Batal)
  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({'status': newStatus});
      
      if (!mounted) return;
      Navigator.pop(context); // Kembali ke list setelah update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status berhasil diubah menjadi: $newStatus"))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data dari parameter
    final data = widget.orderData;
    final status = data['status'] ?? 'Menunggu';
    final bool isClient = MyApp.isClient;
    
    // Logika Tampilan Status
    Color statusColor;
    IconData statusIcon;
    if (status == "Selesai") { 
      statusColor = Colors.green; statusIcon = Icons.check_circle; 
    } else if (status == "Diproses" || status == "Diterima") { 
      statusColor = Colors.blue; statusIcon = Icons.handyman; 
    } else if (status == "Menunggu") { 
      statusColor = Colors.orange; statusIcon = Icons.access_time_filled; 
    } else { 
      statusColor = Colors.red; statusIcon = Icons.cancel; 
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Detail Pesanan", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- 1. KARTU DETAIL UTAMA ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Foto & Nama Lawan Bicara
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(isClient 
                            ? (data['workerImage'] ?? 'assets/images/avatar_placeholder.png')
                            : 'assets/images/avatar_placeholder.png'),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isClient ? (data['workerName'] ?? "Pekerja") : (data['clientName'] ?? "Klien"),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                            ),
                            Text(
                              isClient ? (data['workerRole'] ?? "Penyedia Jasa") : "Pemberi Kerja",
                              style: const TextStyle(fontSize: 12, color: Colors.grey)
                            ),
                          ],
                        ),
                      ),
                      // Badge Status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Row(children: [
                          Icon(statusIcon, color: statusColor, size: 14), 
                          const SizedBox(width: 4), 
                          Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11))
                        ]),
                      )
                    ],
                  ),
                  const Divider(height: 30),
                  
                  // Detail Data
                  _buildDetailRow("Layanan", data['service'] ?? '-'),
                  _buildDetailRow("Jadwal", "${data['date']} • ${data['time']}"),
                  _buildDetailRow("Lokasi", data['location'] ?? '-'),
                  _buildDetailRow("Catatan", data['note'] ?? '-'),
                ],
              ),
            ),
            
            const SizedBox(height: 15),

            // --- 2. MENU LIHAT PROFIL (Khusus Klien) ---
            // Ini akan memperbaiki Warning Unused Import
            if (isClient) ...[
              GestureDetector(
                onTap: () {
                  // Siapkan data pekerja untuk halaman profil
                  final workerProfileData = {
                    'uid': data['workerId'] ?? '',
                    'name': data['workerName'] ?? 'Pekerja',
                    'serviceCategory': data['workerRole'] ?? 'Layanan',
                    'imageUrl': data['workerImage'],
                    'rating': 5.0, // Nilai default karena tidak ada di data order
                    'location': '-',
                    'bio': 'Mitra Lapo Kerja',
                    'skills': data['service'] ?? '',
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkerProfilePage(workerData: workerProfileData)
                    )
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_circle_outlined, color: kPrimaryColor),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text("Lihat Profil Pekerja", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // --- 3. TOMBOL AKSI (DINAMIS) ---
            if (_isLoading) 
              const Center(child: CircularProgressIndicator())
            else 
              _buildActionButtons(status, isClient),
              
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(String status, bool isClient) {
    // 1. KASUS: PEKERJA MELIHAT ORDER BARU (Menunggu)
    if (!isClient && status == "Menunggu") {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _updateStatus("Ditolak"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 15)
              ),
              child: const Text("Tolak"),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus("Diproses"),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15)
              ),
              child: const Text("Terima Pesanan", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }

    // 2. KASUS: PEKERJA MENYELESAIKAN ORDER (Diproses)
    if (!isClient && status == "Diproses") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _updateStatus("Selesai"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 15)),
          child: const Text("Tandai Selesai", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    // 3. KASUS: KLIEN MEMBATALKAN ORDER (Menunggu)
    if (isClient && status == "Menunggu") {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => _updateStatus("Dibatalkan"),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), padding: const EdgeInsets.symmetric(vertical: 15)),
          child: const Text("Batalkan Pesanan"),
        ),
      );
    }

    // 4. KASUS: KLIEN MEMBERI REVIEW (Selesai)
    if (isClient && status == "Selesai") {
      // Cek apakah sudah direview sebelumnya (Opsional, jika data ada field isReviewed)
      bool isReviewed = widget.orderData['isReviewed'] ?? false;

      if (isReviewed) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
          child: const Center(child: Text("Pesanan telah diulas", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        );
      }

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // [UPDATE] Navigasi ke GiveReviewPage dengan Data Lengkap
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => GiveReviewPage(
                  workerId: widget.orderData['workerId'],
                  workerName: widget.orderData['workerName'],
                  workerImage: widget.orderData['workerImage'],
                  orderId: widget.orderId,
                )
              )
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor, 
            padding: const EdgeInsets.symmetric(vertical: 15)
          ),
          child: const Text("Beri Ulasan", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return const SizedBox.shrink(); // Tidak ada tombol untuk status lain
  }
}