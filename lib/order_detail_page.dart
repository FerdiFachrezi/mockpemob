import 'package:flutter/material.dart';
import 'components.dart';
import 'edit_order_page.dart';

class OrderDetailPage extends StatelessWidget {
  final String status; // Menerima status dari list
  const OrderDetailPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // Tentukan warna status
    Color statusColor = (status == "Selesai") ? Colors.green 
        : (status == "Diproses") ? Colors.orange 
        : Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Detail Pesanan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- KARTU DETAIL UTAMA ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
              ),
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
                            const Text("Lala Jola", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Text("Asisten Rumah Tangga", style: TextStyle(fontSize: 11, color: Colors.grey)),
                            const Text("Profesional", style: TextStyle(fontSize: 11, color: Colors.orange)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: statusColor, size: 14), // Icon dummy
                            const SizedBox(width: 4),
                            Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(height: 30),
                  
                  _buildDetailRow("Tipe Layanan", "Pengasuh Anak"),
                  _buildDetailRow("Paket Layanan", "Harian"),
                  _buildDetailRow("Jadwal", "6 Okt 2025"),
                  _buildDetailRow("Waktu Kerja", "08:00 - 16:00"),
                  _buildDetailRow("Lokasi Pekerjaan", "Jalan Dr. T. Mansur No.9 Medan Baru"),
                  _buildDetailRow("Catatan Tambahan", "Tolong ini itu jangan ini itu nanti ini itu......."),
                  _buildDetailRow("Metode Pembayaran", "Bayar Tunai di tempat"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- MENU AKSI (Profile, Hubungi, Ulasan) ---
            _buildActionTile(Icons.person_outline, "Profile Pekerja"),
            const SizedBox(height: 10),
            _buildActionTile(Icons.phone_outlined, "Hubungi Pekerja", subtitle: "Anda bisa berdiskusi terkait detail pekerjaan lebih detail disini."),
            const SizedBox(height: 10),
            _buildActionTile(Icons.rate_review_outlined, "Beri Ulasan ke Pekerja"),

            const SizedBox(height: 30),

            // --- TOMBOL BAWAH (Hanya muncul jika status Diproses) ---
            if (status == "Diproses")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showCancelModal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Batalkan Pesanan", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const EditOrderPage()));
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: kPrimaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Edit Pesanan", style: TextStyle(color: kPrimaryColor)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 3)]),
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- MODAL PEMBATALAN ---
  void _showCancelModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // Variable lokal untuk radio button
        String? selectedReason = "Pekerja tidak membalas";
        
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, color: Colors.black, margin: const EdgeInsets.only(bottom: 20))),
                  const Center(child: Text("Pilih Alasan Pembatalan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  const Text("Mohon pilih alasan pembatalan dan menunggu respon pekerja", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 20),
                  
                  _buildRadioItem("Pekerja tidak membalas", selectedReason, (val) => setState(() => selectedReason = val)),
                  _buildRadioItem("Ingin mengubah rincian & membuat pesanan", selectedReason, (val) => setState(() => selectedReason = val)),
                  _buildRadioItem("Lainnya / Berubah Pikiran", selectedReason, (val) => setState(() => selectedReason = val)),

                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Ajukan Pembatalan", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  )
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildRadioItem(String value, String? groupValue, Function(String?) onChanged) {
    return RadioListTile<String>(
      title: Text(value, style: const TextStyle(fontSize: 13)),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: kPrimaryColor,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}