class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'client' atau 'worker'
  final String? location;
  final String? imageUrl;
  
  // --- Field Khusus Pekerja (Nullable / Boleh Kosong untuk Klien) ---
  final String? serviceCategory; // Contoh: "Asisten Rumah Tangga"
  final String? rateCategory;    // Contoh: "Profesional", "Standar"
  final String? bio;             // Deskripsi singkat
  final String? skills;          // Keahlian, contoh: "Masak, Setrika"
  final double rating;           // Rating bintang (0.0 - 5.0)

  // Constructor
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.location,
    this.imageUrl,
    this.serviceCategory,
    this.rateCategory,
    this.bio,
    this.skills,
    this.rating = 0.0,
  });

  // 1. Factory: Mengubah JSON (Map) dari Firestore menjadi Object Dart
  // Digunakan saat mengambil data dari database untuk ditampilkan di aplikasi
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'client', // Default ke client jika kosong
      location: map['location'] ?? '-',
      imageUrl: map['imageUrl'],
      serviceCategory: map['serviceCategory'],
      rateCategory: map['rateCategory'],
      bio: map['bio'],
      skills: map['skills'],
      // Pastikan rating dikonversi ke double agar tidak error
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }

  // 2. Method: Mengubah Object Dart menjadi JSON (Map)
  // Digunakan saat menyimpan data profil ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'location': location,
      'imageUrl': imageUrl,
      'serviceCategory': serviceCategory,
      'rateCategory': rateCategory,
      'bio': bio,
      'skills': skills,
      'rating': rating,
    };
  }
}