import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart'; // Kita matikan dulu karena tidak upload
import 'components.dart';
import 'main.dart'; 
import 'models/user_model.dart'; 
import 'services/auth_service.dart'; 

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  // Khusus Pekerja
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _tarifController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // State
  bool _isLoading = false;
  String? _photoUrl; // URL foto dari Firebase Auth (Google)

  final List<String> _layananOptions = [
    "Asisten Rumah Tangga", "Pertukangan & Konstruksi", "Edukasi & Akademik",
    "Catering & Acara", "Perawatan & Layanan Pribadi", "Multimedia",
    "Seni & Hiburan", "Pertanian & Peternakan"
  ];
  final List<String> _tarifOptions = ["Profesional", "Standar", "Ekonomis"];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- 1. LOAD DATA ---
  void _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          UserModel userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          setState(() {
            _nameController.text = userModel.name;
            _emailController.text = userModel.email;
            _locationController.text = userModel.location ?? "";
            _photoUrl = userModel.imageUrl; // Ambil URL foto (biasanya dari Google)

            if (userModel.role == 'worker') {
              _serviceController.text = userModel.serviceCategory ?? "";
              _tarifController.text = userModel.rateCategory ?? "";
              _skillsController.text = userModel.skills ?? "";
              _descController.text = userModel.bio ?? "";
            }
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memuat profil: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- 2. SIMPAN PERUBAHAN (HANYA TEKS) ---
  void _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama tidak boleh kosong")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Siapkan Data Model (Tanpa logika upload foto baru)
      String role = MyApp.isClient ? 'client' : 'worker';

      UserModel updatedUser = UserModel(
        uid: user.uid,
        email: _emailController.text,
        name: _nameController.text,
        role: role,
        location: _locationController.text,
        imageUrl: _photoUrl, // Tetap gunakan URL lama (Google/Null)
        
        serviceCategory: !MyApp.isClient ? _serviceController.text : null,
        rateCategory: !MyApp.isClient ? _tarifController.text : null,
        skills: !MyApp.isClient ? _skillsController.text : null,
        bio: !MyApp.isClient ? _descController.text : null,
      );

      // Simpan ke Firestore
      await AuthService().saveUserProfile(updatedUser);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil berhasil diperbarui!")));
      Navigator.pop(context); 

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _nameController.text.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
          children: [
            // --- BAGIAN FOTO PROFIL (READ ONLY) ---
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    // Tampilkan foto Google jika ada, jika tidak pakai Placeholder
                    backgroundImage: (_photoUrl != null && _photoUrl!.isNotEmpty)
                        ? NetworkImage(_photoUrl!) as ImageProvider
                        : const AssetImage('assets/images/avatar_placeholder.png'),
                  ),
                  // Kita hilangkan ikon kamera karena fitur upload dinonaktifkan
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Informasi User
            const Text("Foto Profil (Sesuai Akun Google)", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 30),

            // --- FIELD INPUT ---
            const Align(alignment: Alignment.centerLeft, child: InputLabel(label: "Nama Lengkap")),
            CustomTextField(hintText: "Nama Anda", controller: _nameController),
            const SizedBox(height: 15),

            const Align(alignment: Alignment.centerLeft, child: InputLabel(label: "Email")),
            AbsorbPointer(child: CustomTextField(hintText: "Email Anda", controller: _emailController)),
            const SizedBox(height: 15),

            const Align(alignment: Alignment.centerLeft, child: InputLabel(label: "Lokasi")),
            CustomTextField(hintText: "Alamat Lengkap", controller: _locationController),
            const SizedBox(height: 15),

            // --- KHUSUS PEKERJA ---
            if (!MyApp.isClient) ...[
              const Divider(height: 40),
              const Align(alignment: Alignment.centerLeft, child: InputLabel(label: "Layanan")),
              GestureDetector(
                onTap: () => _showSelectionModal(context, "Ubah Layanan", _layananOptions, _serviceController),
                child: AbsorbPointer(child: CustomTextField(hintText: "Pilih Layanan", controller: _serviceController)),
              ),
              const SizedBox(height: 15),

              const Align(alignment: Alignment.centerLeft, child: InputLabel(label: "Tarif")),
              GestureDetector(
                onTap: () => _showSelectionModal(context, "Ubah Tarif", _tarifOptions, _tarifController),
                child: AbsorbPointer(child: CustomTextField(hintText: "Pilih Tarif", controller: _tarifController)),
              ),
              const SizedBox(height: 15),

              const Align(alignment: Alignment.centerLeft, child: InputLabel(label: "Keahlian")),
              CustomTextField(hintText: "Contoh: Ramah, Disiplin", controller: _skillsController),
              const SizedBox(height: 25),

              const Align(alignment: Alignment.centerLeft, child: InputLabel(label: "Deskripsi")),
              Container(
                height: 150,
                decoration: BoxDecoration(color: kInputFillColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _descController,
                  maxLines: 10,
                  decoration: const InputDecoration.collapsed(hintText: "Tulis deskripsi diri Anda..."),
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
            ],
            
            // --- TOMBOL AKSI ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Konfirmasi", style: TextStyle(color: Colors.white)),
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

  // Helper Modal
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
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.only(bottom: 20)),
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(options[index]), value: options[index], groupValue: controller.text, activeColor: kPrimaryColor, contentPadding: EdgeInsets.zero,
                          onChanged: (value) { 
                            setModalState(() { controller.text = value!; }); 
                            setState(() { controller.text = value!; });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Selesai", style: TextStyle(color: Colors.white)))),
                ],
              ),
            );
          }
        );
      },
    );
  }
}