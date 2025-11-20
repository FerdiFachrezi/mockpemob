import 'package:flutter/material.dart';
import 'components.dart';
import 'profile_page.dart'; // Tujuan setelah setup selesai

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  // Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _specialistController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Data Opsi (Sesuai Gambar)
  final List<String> _serviceOptions = [
    "Asisten Rumah Tangga",
    "Pertukangan & Konstruksi",
    "Edukasi & Akademik",
    "Catering & Acara",
    "Perawatan & Layanan Pribadi",
    "Multimedia",
    "Seni & Hiburan",
    "Pertanian & Peternakan"
  ];

  final List<String> _rateOptions = ["Profesional", "Standar", "Ekonomis"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // --- HEADER TITLE ---
            const Text(
              "Profil Anda",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Buka peluang karir terbaik Anda dengan\nmelengkapi informasi di bawah ini.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 30),

            // --- FOTO PROFIL ---
            Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFFF0F0F0),
                  backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)
                      ],
                    ),
                    child: const Icon(Icons.camera_alt_outlined, size: 18, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text("Tambahkan Foto Profil Anda", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 30),

            // --- FORM INPUT ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InputLabel(label: "Nama Lengkap"),
                CustomTextField(hintText: "Lala Jola", controller: _nameController),
                const SizedBox(height: 15),

                const InputLabel(label: "Email"),
                CustomTextField(hintText: "lalajola123@gmail.com", controller: _emailController),
                const SizedBox(height: 15),

                const InputLabel(label: "Lokasi"),
                CustomTextField(hintText: "Medan Tembung", controller: _locationController),
                const SizedBox(height: 15),

                // Pilihan Layanan (Modal)
                const InputLabel(label: "Layanan"),
                GestureDetector(
                  onTap: () => _showSelectionModal(context, "Pilih Layanan", _serviceOptions, _serviceController),
                  child: AbsorbPointer(
                    child: CustomTextField(hintText: "Pilih Layanan", controller: _serviceController),
                  ),
                ),
                const SizedBox(height: 15),

                const InputLabel(label: "Spesialis"),
                CustomTextField(hintText: "Pengasuh Anak, Perawat Lansia", controller: _specialistController),
                const SizedBox(height: 15),

                // Pilihan Tarif (Modal)
                const InputLabel(label: "Tarif"),
                GestureDetector(
                  onTap: () => _showSelectionModal(context, "Pilih Tarif", _rateOptions, _rateController),
                  child: AbsorbPointer(
                    child: CustomTextField(hintText: "Pilih Tarif", controller: _rateController),
                  ),
                ),
                const SizedBox(height: 15),

                const InputLabel(label: "Keahlian"),
                CustomTextField(hintText: "Ramah, Disiplin, Berpengalaman", controller: _skillsController),
                const SizedBox(height: 25),

                // Upload Sampul (Dashed Border style visual)
                Container(
                  height: 100,
                  width: double.infinity,
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
                      Text("Tambahkan\nSampul Anda", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Deskripsi
                const InputLabel(label: "Deskripsi"),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: kInputFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _descController,
                    maxLines: 10,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Halo Ayah & Bunda! Kenalin, saya Lala...",
                    ),
                    style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- TOMBOL AKSI ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context), // Batal
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: kPrimaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text("Batal", style: TextStyle(color: kPrimaryColor, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Selesai Setup -> Masuk ke Aplikasi Utama (Profile)
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                        (route) => false, // Hapus history login/signup agar tidak bisa back
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text("Konfirmasi", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- MODAL BOTTOM SHEET (Reusable Logic) ---
  void _showSelectionModal(BuildContext context, String title, List<String> options, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar bisa full height jika konten banyak
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6, // Set tinggi modal
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle Bar Kecil
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10))),
              
              // Header Modal
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.grey)),
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 40), // Spacer dummy agar text center
                  ],
                ),
              ),

              const Divider(height: 1),

              // List Opsi
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(options[index], style: const TextStyle(color: Colors.black54)),
                          value: options[index],
                          groupValue: controller.text,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            setState(() {
                              controller.text = value!;
                            });
                          },
                        );
                      },
                    );
                  }
                ),
              ),

              // Tombol Konfirmasi di Modal
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Konfirmasi Pilihan", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}