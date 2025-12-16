import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components.dart';
import 'main_nav.dart';

class GiveReviewPage extends StatefulWidget {
  final String workerId;
  final String workerName;
  final String? workerImage;
  final String orderId;

  const GiveReviewPage({
    super.key,
    required this.workerId,
    required this.workerName,
    this.workerImage,
    required this.orderId,
  });

  @override
  State<GiveReviewPage> createState() => _GiveReviewPageState();
}

class _GiveReviewPageState extends State<GiveReviewPage> {
  int _selectedRating = 0;
  String _selectedResponseSpeed = "Cepat"; 
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  final List<String> _responseOptions = ["Cepat", "Sedang", "Lambat"];

  Future<void> _submitReview() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon berikan penilaian bintang."))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("permission-denied"); // Simulasi error jika user null
      }

      // 1. Simpan Ulasan
      await FirebaseFirestore.instance.collection('reviews').add({
        'workerId': widget.workerId,
        'clientId': user.uid,
        'clientName': user.displayName ?? "Pengguna",
        'clientImage': user.photoURL,
        'rating': _selectedRating,
        'responseSpeed': _selectedResponseSpeed,
        'comment': _commentController.text,
        'orderId': widget.orderId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Update Rating Worker
      final workerRef = FirebaseFirestore.instance.collection('users').doc(widget.workerId);
      
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot workerDoc = await transaction.get(workerRef);
        if (workerDoc.exists) {
          Map<String, dynamic> data = workerDoc.data() as Map<String, dynamic>;
          double currentRating = (data['rating'] ?? 0.0).toDouble();
          int reviewCount = (data['reviewCount'] ?? 0).toInt();
          double newRating = ((currentRating * reviewCount) + _selectedRating) / (reviewCount + 1);
          
          transaction.update(workerRef, {
            'rating': newRating,
            'reviewCount': reviewCount + 1,
            'avgResponseSpeed': _selectedResponseSpeed, 
          });
        }
      });

      // 3. Update Order Status
      await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
        'isReviewed': true, 
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terima kasih! Ulasan berhasil dikirim."))
      );
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNav(initialIndex: 0)),
        (route) => false,
      );

    } catch (e) {
      // [UPDATE] Menggunakan pesan error yang ramah
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(getFriendlyErrorMessage(e)))
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Beri Ulasan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Bagaimana pengalaman Anda menggunakan jasa ini?", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  CircleAvatar(radius: 25, backgroundImage: AssetImage(widget.workerImage ?? 'assets/images/avatar_placeholder.png')),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.workerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text("Penyedia Jasa", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedRating = index + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(index < _selectedRating ? Icons.star : Icons.star_border_rounded, color: index < _selectedRating ? Colors.orange : Colors.grey.shade300, size: 45),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(_selectedRating == 0 ? "Sentuh bintang untuk menilai" : _getRatingLabel(_selectedRating), style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const SizedBox(height: 30),
            const Align(alignment: Alignment.centerLeft, child: Text("Kecepatan Respon Pekerja", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.spaceEvenly,
                children: _responseOptions.map((option) {
                  bool isSelected = _selectedResponseSpeed == option;
                  return ChoiceChip(
                    label: Text(option),
                    selected: isSelected,
                    selectedColor: kPrimaryColor,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedResponseSpeed = option);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: const InputDecoration.collapsed(hintText: "Tuliskan pengalaman Anda di sini..."),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("KIRIM ULASAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1: return "Sangat Buruk";
      case 2: return "Buruk";
      case 3: return "Cukup";
      case 4: return "Bagus";
      case 5: return "Sangat Memuaskan!";
      default: return "";
    }
  }
}