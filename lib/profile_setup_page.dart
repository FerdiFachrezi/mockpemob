import 'package:flutter/material.dart';
import 'components.dart';
import 'main_nav.dart';
import 'main.dart'; // Akses MyApp.isClient
import 'models/user_model.dart'; // Model data user
import 'services/auth_service.dart'; // Service untuk simpan ke Firestore

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  // --- CONTROLLER INPUT ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  // Khusus Pekerja
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _specialistController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // State untuk Loading
  bool _isLoading = false;

  // Data Opsi (Hardcoded untuk UI)
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

  // --- FUNGSI SUBMIT KE FIREBASE ---
  void _submitProfile() async {
    // 1. Validasi Input Dasar
    if (_nameController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Lokasi wajib diisi!"))
      );
      return;
    }

    setState(() {
      _isLoading = true; // Mulai Loading
    });

    try {
      // 2. Ambil User yang sedang login (dari Auth)
      final currentUser = AuthService().currentUser;
      
      if (currentUser != null) {
        // 3. Tentukan Role
        String role = MyApp.isClient ? 'client' : 'worker';

        // 4. Bungkus data ke dalam Model
        UserModel newUser = UserModel(
          uid: currentUser.uid,
          email: currentUser.email ?? _emailController.text, // Fallback jika email null
          name: _nameController.text,
          role: role,
          location: _locationController.text,
          // Field khusus Pekerja (hanya diisi jika role == worker)
          serviceCategory: role == 'worker' ? _serviceController.text : null,
          rateCategory: role == 'worker' ? _rateController.text : null,
          bio: _descController.text.isNotEmpty ? _descController.text : null,
          // (Opsional: Tambahkan field lain seperti specialist atau skills ke model jika sudah diupdate)
        );

        // 5. Simpan ke Firestore via Service
        await AuthService().saveUserProfile(newUser);

        if (!mounted) return; // Cek jika widget masih aktif

        // 6. Sukses: Navigasi ke Halaman Utama (Home)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNav()),
          (route) => false, 
        );
      } else {
        throw Exception("User tidak ditemukan. Silakan login ulang.");
      }
    } catch (e) {
      // 7. Error Handling
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan profil: ${e.toString()}"))
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop Loading
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Auto-fill email jika tersedia dari Auth (Opsional)
    final user = AuthService().currentUser;
    if (user?.email != null) {
      _emailController.text = user!.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cek Role untuk Menampilkan/Menyembunyikan Field
    bool isWorker = !MyApp.isClient;

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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kTextColor),
            ),
            const SizedBox(height: 8),
            const Text(
              "Lengkapi informasi Anda untuk pengalaman terbaik.",
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
                  bottom: 0, right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)],
                    ),
                    child: const Icon(Icons.camera_alt_outlined, size: 18, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- FORM INPUT ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InputLabel(label: "Nama Lengkap"),
                CustomTextField(hintText: "Nama Anda", controller: _nameController),
                const SizedBox(height: 15),

                const InputLabel(label: "Email"),
                // Email biasanya read-only karena dari login
                AbsorbPointer(
                  child: CustomTextField(hintText: "email@anda.com", controller: _emailController),
                ),
                const SizedBox(height: 15),

                const InputLabel(label: "Lokasi / Alamat"),
                CustomTextField(hintText: "Contoh: Medan Baru", controller: _locationController),
                const SizedBox(height: 15),

                // --- FIELD KHUSUS PEKERJA ---
                if (isWorker) ...[
                  const InputLabel(label: "Kategori Layanan"),
                  GestureDetector(
                    onTap: () => _showSelectionModal(context, "Pilih Layanan", _serviceOptions, _serviceController),
                    child: AbsorbPointer(
                      child: CustomTextField(hintText: "Pilih Kategori", controller: _serviceController),
                    ),
                  ),
                  const SizedBox(height: 15),

                  const InputLabel(label: "Spesialisasi"),
                  CustomTextField(hintText: "Contoh: Masakan Nusantara, Jaga Balita", controller: _specialistController),
                  const SizedBox(height: 15),

                  const InputLabel(label: "Tarif"),
                  GestureDetector(
                    onTap: () => _showSelectionModal(context, "Pilih Tarif", _rateOptions, _rateController),
                    child: AbsorbPointer(
                      child: CustomTextField(hintText: "Pilih Tarif", controller: _rateController),
                    ),
                  ),
                  const SizedBox(height: 15),

                  const InputLabel(label: "Keahlian Utama"),
                  CustomTextField(hintText: "Contoh: Sabar, Cekatan, Jujur", controller: _skillsController),
                  const SizedBox(height: 25),

                  // Deskripsi
                  const InputLabel(label: "Deskripsi Diri"),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: kInputFillColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _descController,
                      maxLines: 5,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Ceritakan sedikit tentang pengalaman dan diri Anda...",
                      ),
                      style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 30),

            // --- TOMBOL AKSI ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                    onPressed: _isLoading ? null : _submitProfile, // Panggil fungsi submit
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: _isLoading 
                      ? const SizedBox(
                          height: 20, width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text("Simpan Profil", style: TextStyle(color: Colors.white, fontSize: 16)),
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

  // --- MODAL BOTTOM SHEET (Helper) ---
  void _showSelectionModal(BuildContext context, String title, List<String> options, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(options[index]),
                      onTap: () {
                        setState(() => controller.text = options[index]);
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