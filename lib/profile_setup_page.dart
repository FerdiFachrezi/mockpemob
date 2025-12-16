import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components.dart';
import 'main_nav.dart'; 
import 'main.dart'; // Akses MyApp.isClient
import 'models/user_model.dart'; // Import Model User
import 'services/auth_service.dart'; // Import Service Auth

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  // --- CONTROLLERS ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  // Khusus Pekerja
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // State Loading
  bool _isLoading = false;

  // Data Opsi Dropdown/Modal
  final List<String> _serviceOptions = [
    "Asisten Rumah Tangga", "Pertukangan & Konstruksi", "Edukasi & Akademik",
    "Catering & Acara", "Perawatan & Layanan Pribadi", "Multimedia",
    "Seni & Hiburan", "Pertanian & Peternakan"
  ];
  final List<String> _rateOptions = ["Profesional", "Standar", "Ekonomis"];

  @override
  void initState() {
    super.initState();
    // Auto-fill nama & email dari akun Auth saat ini (misal dari Google Login)
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? "";
      _emailController.text = user.email ?? "";
    }
  }

  // --- FUNGSI SIMPAN PROFIL ---
  void _saveProfile() async {
    // 1. Validasi Input Dasar
    if (_nameController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Lokasi wajib diisi!"))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User tidak ditemukan/belum login.");

      // 2. Tentukan Role
      String role = MyApp.isClient ? 'client' : 'worker';

      // 3. Bungkus Data ke dalam UserModel
      UserModel newUser = UserModel(
        uid: user.uid,
        email: user.email!,
        name: _nameController.text,
        role: role,
        location: _locationController.text,
        imageUrl: user.photoURL, // Ambil foto dari Google jika ada
        
        // Data Khusus Pekerja (Hanya diisi jika bukan Client)
        serviceCategory: !MyApp.isClient ? _serviceController.text : null,
        rateCategory: !MyApp.isClient ? _rateController.text : null,
        skills: !MyApp.isClient ? _skillsController.text : null,
        bio: !MyApp.isClient ? _descController.text : null,
      );

      // 4. Simpan ke Firestore via AuthService
      await AuthService().saveUserProfile(newUser);

      if (!mounted) return;

      // 5. Sukses -> Masuk ke Halaman Utama (Home)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNav()),
        (route) => false, 
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan profil: $e"))
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWorker = !MyApp.isClient; // Cek apakah pekerja

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lengkapi Profil", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            const Text(
              "Data ini akan ditampilkan di profil Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 30),

            // Foto Profil (Placeholder)
            Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFFF0F0F0),
                  backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                ),
                Positioned(
                  bottom: 0, right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]
                    ),
                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- FORM DATA PRIBADI (SEMUA USER) ---
            const InputLabel(label: "Nama Lengkap"),
            CustomTextField(hintText: "Nama Anda", controller: _nameController),
            const SizedBox(height: 15),

            const InputLabel(label: "Email"),
            // AbsorbPointer agar email tidak bisa diedit (read-only)
            AbsorbPointer(
              child: CustomTextField(hintText: "email@anda.com", controller: _emailController)
            ),
            const SizedBox(height: 15),

            const InputLabel(label: "Lokasi"),
            CustomTextField(hintText: "Contoh: Medan Baru", controller: _locationController),
            const SizedBox(height: 15),

            // --- FORM KHUSUS PEKERJA ---
            if (isWorker) ...[
              const Divider(height: 40, thickness: 1),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Informasi Pekerjaan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 20),

              const InputLabel(label: "Kategori Layanan"),
              GestureDetector(
                onTap: () => _showSelectionModal(context, "Pilih Layanan", _serviceOptions, _serviceController),
                child: AbsorbPointer(
                  child: CustomTextField(hintText: "Pilih Kategori", controller: _serviceController)
                ),
              ),
              const SizedBox(height: 15),

              const InputLabel(label: "Tarif / Level"),
              GestureDetector(
                onTap: () => _showSelectionModal(context, "Pilih Tarif", _rateOptions, _rateController),
                child: AbsorbPointer(
                  child: CustomTextField(hintText: "Pilih Tarif", controller: _rateController)
                ),
              ),
              const SizedBox(height: 15),

              const InputLabel(label: "Keahlian (Skills)"),
              CustomTextField(hintText: "Contoh: Sabar, Telaten, Masak", controller: _skillsController),
              const SizedBox(height: 15),

              const InputLabel(label: "Deskripsi Diri"),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kInputFillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: const InputDecoration.collapsed(hintText: "Ceritakan sedikit tentang pengalaman Anda..."),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],

            const SizedBox(height: 40),

            // --- TOMBOL SIMPAN ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("SIMPAN PROFIL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- HELPER: MODAL BOTTOM SHEET ---
  void _showSelectionModal(BuildContext context, String title, List<String> options, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(options[index]),
                      onTap: () {
                        controller.text = options[index];
                        Navigator.pop(context);
                      },
                      trailing: controller.text == options[index] 
                          ? const Icon(Icons.check_circle, color: kPrimaryColor) 
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}