import 'package:flutter/material.dart';
import 'components.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ulasan Klien Tentang Anda", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Ulasan Anda membantu kami menjaga kualitas layanan",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            
            // Kartu Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/avatar_placeholder.png'), // Ganti foto
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lala Jola", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Asisten Rumah Tangga", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nilai Rating Besar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
              ),
              child: const Column(
                children: [
                  Text("5.0/5.0", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: kPrimaryColor, size: 30),
                      Icon(Icons.star, color: kPrimaryColor, size: 30),
                      Icon(Icons.star, color: kPrimaryColor, size: 30),
                      Icon(Icons.star, color: kPrimaryColor, size: 30),
                      Icon(Icons.star, color: kPrimaryColor, size: 30),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List Ulasan User
            Expanded(
              child: ListView(
                children: [
                  _buildReviewCard("Lapo Kerja", "Pengasuh Anak", "Pelayanan sangat memuaskan, anak saya senang sekali!"),
                  _buildReviewCard("Budi Santoso", "Dosen", "Sangat disiplin dan bersih. Rekomended."),
                  _buildReviewCard("Siti Aminah", "Ibu Rumah Tangga", "Orangnya ramah banget."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(String name, String role, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey, 
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(role, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
               Icon(Icons.star, color: kPrimaryColor, size: 16),
               Icon(Icons.star, color: kPrimaryColor, size: 16),
               Icon(Icons.star, color: kPrimaryColor, size: 16),
               Icon(Icons.star, color: kPrimaryColor, size: 16),
               Icon(Icons.star, color: kPrimaryColor, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}