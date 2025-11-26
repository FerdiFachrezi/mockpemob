import 'package:flutter/material.dart';
import 'components.dart';
import 'main.dart'; // Import untuk akses MyApp.isClient

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controller (diisi data mock sesuai role)
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  final TextEditingController _layananController = TextEditingController(text: "Asisten Rumah Tangga");
  final TextEditingController _tarifController = TextEditingController(text: "Profesional");

  @override
  void initState() {
    super.initState();
    // Inisialisasi data mock berdasarkan role
    if (MyApp.isClient) {
      _nameController = TextEditingController(text: "Lapo Kerja");
      _emailController = TextEditingController(text: "lapokerja123@gmail.com");
      _locationController = TextEditingController(text: "Jalan Dr. T. Mansur No.9 Medan Baru");
    } else {
      _nameController = TextEditingController(text: "Lala Jola");
      _emailController = TextEditingController(text: "lalajola123@gmail.com");
      _locationController = TextEditingController(text: "Medan Tembung");
    }
  }

  // Opsi Modal (sama seperti sebelumnya)
  final List<String> _layananOptions = ["Asisten Rumah Tangga", "Pertukangan & Konstruksi", "Edukasi & Akademik", "Catering & Acara"];
  final List<String> _tarifOptions = ["Profesional", "Standar", "Ekonomis"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Profil Edit
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/avatar_placeholder.png'), 
                    backgroundColor: Colors.grey,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Center(child: Text("Ubah Foto Profil", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 30),

            // Field Dasar (Tampil untuk Klien & Pekerja)
            const InputLabel(label: "Nama Lengkap"),
            CustomTextField(hintText: "", controller: _nameController),
            const SizedBox(height: 15),

            const InputLabel(label: "Email"),
            CustomTextField(hintText: "", controller: _emailController),
            const SizedBox(height: 15),

            const InputLabel(label: "Lokasi"),
            CustomTextField(hintText: "", controller: _locationController),
            const SizedBox(height: 15),

            // --- BAGIAN KHUSUS PEKERJA (Disembunyikan jika Klien) ---
            if (!MyApp.isClient) ...[
              const InputLabel(label: "Layanan"),
              GestureDetector(
                onTap: () => _showSelectionModal(context, "Ubah Layanan", _layananOptions, _layananController),
                child: AbsorbPointer(child: CustomTextField(hintText: "", controller: _layananController)),
              ),
              const SizedBox(height: 15),

              const InputLabel(label: "Spesialis"),
              const CustomTextField(hintText: "Pengasuh Anak, Perawat Lansia"),
              const SizedBox(height: 15),

              const InputLabel(label: "Tarif"),
              GestureDetector(
                onTap: () => _showSelectionModal(context, "Ubah Tarif", _tarifOptions, _tarifController),
                child: AbsorbPointer(child: CustomTextField(hintText: "", controller: _tarifController)),
              ),
              const SizedBox(height: 15),

              const InputLabel(label: "Keahlian"),
              const CustomTextField(hintText: "Ramah, Disiplin, Berpengalaman"),
              const SizedBox(height: 25),

              // Area Upload Sampul
              Container(
                height: 100, width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade100),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.drive_folder_upload_outlined, color: kPrimaryColor),
                    SizedBox(height: 5),
                    Text("Ganti/Tambahkan\nSampul Anda", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Deskripsi Area
              const InputLabel(label: "Deskripsi"),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: kInputFillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(12),
                child: const TextField(
                  maxLines: 10,
                  decoration: InputDecoration.collapsed(hintText: "Tulis deskripsi diri Anda..."),
                  style: TextStyle(fontSize: 13, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
            ],
            // ---------------------------------------------------------
            
            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: kPrimaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Batal", style: TextStyle(color: kPrimaryColor)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Konfirmasi Perubahan", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Fungsi Modal Bottom Sheet (Tidak ada perubahan)
  void _showSelectionModal(BuildContext context, String title, List<String> options, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20), height: 500,
              child: Column(
                children: [
                  Container(width: 40, height: 4, color: Colors.grey[300], margin: const EdgeInsets.only(bottom: 20)),
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(options[index]), value: options[index], groupValue: controller.text, activeColor: kPrimaryColor, contentPadding: EdgeInsets.zero,
                          onChanged: (value) { setModalState(() { controller.text = value!; }); },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Konfirmasi Perubahan", style: TextStyle(color: Colors.white)))),
                ],
              ),
            );
          }
        );
      },
    );
  }
}