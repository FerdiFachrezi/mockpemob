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
  final TextEditingController? controller; // <--- TAMBAHAN BARU

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isVisible = false,
    this.onVisibilityToggle,
    this.controller, // <--- TAMBAHAN BARU
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kInputFillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300), // Tambahan border tipis biar lebih tegas
      ),
      child: TextField(
        controller: controller, // <--- DIPASANG DISINI
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
// File: lib/components.dart

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
            // Langsung menampilkan Gambar tanpa Container/Lingkaran putih
            Image.asset(
              'assets/images/google.png',
              height: 24, // Ukuran sedikit diperbesar agar proporsional
              width: 24,
            ),
            const SizedBox(width: 12), // Jarak antara logo dan teks
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