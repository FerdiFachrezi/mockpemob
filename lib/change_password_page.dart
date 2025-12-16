import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components.dart'; // Untuk CustomTextField, PrimaryButton, getFriendlyErrorMessage

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isLoading = false;
  bool _oldPassVisible = false;
  bool _newPassVisible = false;
  bool _confirmPassVisible = false;

  Future<void> _changePassword() async {
    // 1. Validasi Input Dasar
    if (_oldPassController.text.isEmpty || 
        _newPassController.text.isEmpty || 
        _confirmPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom harus diisi"))
      );
      return;
    }

    if (_newPassController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru dan konfirmasi tidak cocok"))
      );
      return;
    }

    if (_newPassController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru minimal 6 karakter"))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      String email = user?.email ?? "";

      // 2. Re-Autentikasi (Wajib untuk ganti password di Firebase)
      // Kita harus memastikan yang mengganti password adalah pemilik akun asli
      AuthCredential credential = EmailAuthProvider.credential(
        email: email, 
        password: _oldPassController.text
      );

      await user?.reauthenticateWithCredential(credential);

      // 3. Update Password
      await user?.updatePassword(_newPassController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password berhasil diubah!"))
      );
      
      Navigator.pop(context); // Kembali ke profil

    } catch (e) {
      // Menangkap error (misal: password lama salah)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(getFriendlyErrorMessage(e)),
        )
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Ganti Password", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Buat password baru yang kuat untuk melindungi akun Anda.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),

            const InputLabel(label: "Password Lama"),
            CustomTextField(
              hintText: "Masukkan password saat ini",
              isPassword: true,
              isVisible: _oldPassVisible,
              controller: _oldPassController,
              onVisibilityToggle: () => setState(() => _oldPassVisible = !_oldPassVisible),
            ),
            
            const SizedBox(height: 20),

            const InputLabel(label: "Password Baru"),
            CustomTextField(
              hintText: "Minimal 6 karakter",
              isPassword: true,
              isVisible: _newPassVisible,
              controller: _newPassController,
              onVisibilityToggle: () => setState(() => _newPassVisible = !_newPassVisible),
            ),

            const SizedBox(height: 20),

            const InputLabel(label: "Konfirmasi Password Baru"),
            CustomTextField(
              hintText: "Ulangi password baru",
              isPassword: true,
              isVisible: _confirmPassVisible,
              controller: _confirmPassController,
              onVisibilityToggle: () => setState(() => _confirmPassVisible = !_confirmPassVisible),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("SIMPAN PASSWORD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}