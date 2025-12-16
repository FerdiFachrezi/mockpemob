import 'package:flutter/material.dart';
import 'components.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, leading: const BackButton(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const InputLabel(label: "Password Lama"),
            const CustomTextField(hintText: "********", isPassword: true),
            const SizedBox(height: 15),
            const InputLabel(label: "Password Baru"),
            const CustomTextField(hintText: "********", isPassword: true),
            const SizedBox(height: 15),
            const InputLabel(label: "Konfirmasi Password Baru"),
            const CustomTextField(hintText: "********", isPassword: true),
            const Spacer(),
            PrimaryButton(text: "Simpan Password", onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}