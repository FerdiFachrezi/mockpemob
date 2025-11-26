import 'package:flutter/material.dart';
import 'components.dart';

class EditOrderPage extends StatefulWidget {
  const EditOrderPage({super.key});

  @override
  State<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  // Mock Controllers
  final TextEditingController _dateController = TextEditingController(text: "6 Okt 2025");
  final TextEditingController _timeController = TextEditingController(text: "08:00 - 16:00");
  final TextEditingController _locationController = TextEditingController(text: "Gunakan Lokasi Saat Ini");
  final TextEditingController _addressDetailController = TextEditingController(text: "Jalan Dr. T. Mansur No.9 Medan Baru");
  final TextEditingController _notesController = TextEditingController();

  // Mock Dropdown values
  String selectedService = "Pengasuh Anak";
  String selectedPackage = "Harian";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Pesanan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
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
            // Header Profile Kecil
            Row(
              children: [
                const CircleAvatar(backgroundImage: AssetImage('assets/images/avatar_placeholder.png')),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lala Jola", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Profesional", style: TextStyle(color: Colors.orange, fontSize: 10)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

            // Form
            const InputLabel(label: "Pilih Tipe Layanan"),
            _buildDropdown(selectedService, ["Pengasuh Anak", "Perawat Lansia"]),
            
            const SizedBox(height: 15),
            const InputLabel(label: "Pilih Paket Layanan"),
            Row(
              children: [
                _buildChip("Harian", true),
                const SizedBox(width: 10),
                _buildChip("Mingguan", false),
                const SizedBox(width: 10),
                _buildChip("Bulanan", false),
              ],
            ),

            const SizedBox(height: 15),
            const InputLabel(label: "Atur Jadwal"),
            CustomTextField(hintText: "", controller: _dateController), // Idealnya pakai DatePicker
            const SizedBox(height: 10),
            CustomTextField(hintText: "", controller: _timeController),

            const SizedBox(height: 15),
            const InputLabel(label: "Lokasi Pekerjaan"),
            CustomTextField(hintText: "", controller: _locationController),
            const SizedBox(height: 10),
            CustomTextField(hintText: "", controller: _addressDetailController),

            const SizedBox(height: 15),
            const InputLabel(label: "Catatan Tambahan"),
            CustomTextField(hintText: "Opsional", controller: _notesController),

            const SizedBox(height: 15),
            const InputLabel(label: "Metode Pembayaran"),
            _buildRadioPayment("Bayar Tunai di tempat", true),
            _buildRadioPayment("Transfer Bank", false),
            _buildRadioPayment("E - Wallet", false),

            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: kPrimaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: const Text("Batal", style: TextStyle(color: kPrimaryColor)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: const Text("Konfirmasi Perubahan", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: kInputFillColor
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Chip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
      backgroundColor: isSelected ? kPrimaryColor : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? kPrimaryColor : Colors.grey)),
    );
  }

  Widget _buildRadioPayment(String label, bool isSelected) {
    return Row(
      children: [
        Radio(value: isSelected, groupValue: true, onChanged: (val){}, activeColor: Colors.black),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}