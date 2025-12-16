import 'package:flutter/material.dart';

// --- KONFIGURASI WARNA ---
const Color kPrimaryColor = Color(0xFF120A50);
const Color kSecondaryColor = Color(0xFFD6CFF9);
const Color kInputFillColor = Color(0xFFF8F9FA);
const Color kTextColor = Color(0xFF120A50);

// --- WIDGET CUSTOM ---

// Label di atas input field
class InputLabel extends StatelessWidget {
  final String label;
  const InputLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: kTextColor,
          fontSize: 14,
        ),
      ),
    );
  }
}

// Text Field Kustom
class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final bool isVisible;
  final VoidCallback? onVisibilityToggle;
  final TextEditingController? controller; 

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isVisible = false,
    this.onVisibilityToggle,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kInputFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller, 
        obscureText: isPassword && !isVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
        ),
      ),
    );
  }
}

// Tombol Utama (Biru Tua)
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

// Tombol Google (Ungu Muda)
class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.png',
              height: 24, 
              width: 24,
            ),
            const SizedBox(width: 12), 
            const Text(
              "MASUK DENGAN GOOGLE",
              style: TextStyle(
                color: kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- [BARU] HELPER: PENERJEMAH ERROR ---
// Fungsi ini mengubah kode error Firebase menjadi bahasa Indonesia yang ramah
String getFriendlyErrorMessage(dynamic error) {
  String e = error.toString().toLowerCase();

  if (e.contains("permission-denied") || e.contains("permission_denied")) {
    return "Akses ditolak. Pastikan Anda sudah login atau memiliki izin.";
  }
  if (e.contains("unavailable") || e.contains("network") || e.contains("offline")) {
    return "Gagal terhubung. Periksa koneksi internet Anda.";
  }
  if (e.contains("not-found")) {
    return "Data tidak ditemukan.";
  }
  if (e.contains("requires an index")) {
    return "Sistem sedang mengoptimalkan database. Silakan coba sesaat lagi.";
  }
  if (e.contains("user-not-found")) {
    return "Akun tidak ditemukan. Silakan daftar terlebih dahulu.";
  }
  if (e.contains("wrong-password")) {
    return "Password salah. Silakan coba lagi.";
  }
  if (e.contains("email-already-in-use")) {
    return "Email sudah terdaftar. Gunakan email lain atau login.";
  }
  if (e.contains("invalid-email")) {
    return "Format email tidak valid.";
  }
  if (e.contains("weak-password")) {
    return "Password terlalu lemah (min. 6 karakter).";
  }
  if (e.contains("cancelled")) {
    return "Operasi dibatalkan.";
  }

  // Jika error tidak dikenali, tampilkan pesan umum
  return "Terjadi kesalahan sistem. Silakan coba lagi nanti.";
}