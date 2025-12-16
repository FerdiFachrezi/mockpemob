import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Akses User
import 'components.dart';
import 'profile_setup_page.dart'; // Halaman tujuan setelah daftar
import 'services/auth_service.dart'; // Service Auth
import 'main.dart'; // PENTING: Untuk akses & update MyApp.isClient

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controller Input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false; 
  
  // State lokal untuk pilihan Role (Default ambil dari pilihan WelcomePage)
  late bool _isClientSelected;

  @override
  void initState() {
    super.initState();
    // Inisialisasi status role dari global variable
    _isClientSelected = MyApp.isClient;
  }

  // --- LOGIKA PENDAFTARAN ---
  void _handleSignUp() async {
    // 1. Validasi Input
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom wajib diisi!"))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Update Role Global sesuai pilihan terakhir di halaman ini
      MyApp.isClient = _isClientSelected;

      // 3. Buat Akun di Firebase Auth
      User? user = await AuthService().signUp(
        _emailController.text.trim(), 
        _passController.text.trim()
      );
      
      if (user != null) {
        // 4. Update Display Name (Simpan Nama di Auth sementara)
        await user.updateDisplayName(_nameController.text.trim());
        await user.reload(); 

        if (!mounted) return;

        // 5. Navigasi ke Setup Profil
        // Di halaman ProfileSetupPage nanti, data akan disimpan ke Firestore
        // berdasarkan role (MyApp.isClient) yang sudah kita set di sini.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
        );
      }
    } catch (e) {
      // Error Handling
      String message = "Gagal mendaftar: ${e.toString()}";
      if (e.toString().contains("email-already-in-use")) {
        message = "Email sudah terdaftar. Silakan login.";
      } else if (e.toString().contains("weak-password")) {
        message = "Password terlalu lemah (min. 6 karakter).";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(message))
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    "Buat Akun Baru",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(child: Text("Silakan lengkapi data diri Anda", style: TextStyle(color: Colors.grey))),
                const SizedBox(height: 30),

                // --- PILIHAN ROLE (Klien / Pekerja) ---
                // Sesuai SRS: Meminta tipe akun pada saat registrasi 
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: kInputFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      _buildRoleTab("Saya Klien", true),
                      _buildRoleTab("Saya Pekerja", false),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // --- FORM INPUT ---
                const InputLabel(label: "Nama Lengkap"),
                CustomTextField(
                  hintText: "Nama Anda",
                  controller: _nameController, 
                ),
                const SizedBox(height: 20),

                const InputLabel(label: "Email"),
                CustomTextField(
                  hintText: "email@contoh.com",
                  controller: _emailController, 
                ),
                const SizedBox(height: 20),

                const InputLabel(label: "Sandi"),
                CustomTextField(
                  hintText: "••••••••••••",
                  isPassword: true,
                  isVisible: _isPasswordVisible,
                  controller: _passController, 
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),

                // Tombol DAFTAR
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("DAFTAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                  ),
                ),
                
                const SizedBox(height: 15),
                GoogleButton(onPressed: () {}),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Kamu sudah memiliki akun? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Kembali ke Login
                      },
                      child: const Text(
                        "Masuk",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Tab Role
  Widget _buildRoleTab(String title, bool isClientTab) {
    bool isActive = _isClientSelected == isClientTab;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isClientSelected = isClientTab;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? kPrimaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.grey,
              fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}