class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'client' atau 'worker'
  final String? location;
  final String? imageUrl;
  // Khusus Pekerja
  final String? serviceCategory; // e.g. ART, Pertukangan [cite: 40]
  final String? rateCategory; // e.g. Profesional, Standar
  final String? bio;
  final double rating;

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
    this.rating = 0.0,
  });

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
      'rating': rating,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'client',
      location: map['location'],
      imageUrl: map['imageUrl'],
      serviceCategory: map['serviceCategory'],
      rateCategory: map['rateCategory'],
      bio: map['bio'],
      rating: (map['rating'] ?? 0.0).toDouble(),
    );
  }
}