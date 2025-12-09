import 'package:flutter/material.dart';
import 'components.dart';

class EditOrderPage extends StatelessWidget {
  const EditOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan CustomTextField agar rapi sama seperti Edit Profile
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Pesanan", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, leading: const BackButton(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputLabel(label: "Atur Jadwal"),
            const CustomTextField(hintText: "6 Okt 2025"),
            const SizedBox(height: 15),
            const InputLabel(label: "Lokasi"),
            const CustomTextField(hintText: "Jalan Dr. T Mansur"),
            const SizedBox(height: 15),
            const InputLabel(label: "Catatan"),
            Container(
              height: 100,
              decoration: BoxDecoration(color: kInputFillColor, borderRadius: BorderRadius.circular(12)),
              child: const TextField(maxLines: 5, decoration: InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(10))),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Batal"))),
                const SizedBox(width: 15),
                Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Simpan", style: TextStyle(color: Colors.white)))),
              ],
            )
          ],
        ),
      ),
    );
  }
}