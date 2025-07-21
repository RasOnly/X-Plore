// lib/models/akun.dart
class Akun {
  final int id;
  final String nama;
  final String email;
  final String?
  role; // Sesuaikan dengan struktur data Akun Anda dari backend Go

  Akun({required this.id, required this.nama, required this.email, this.role});

  // Factory constructor untuk membuat objek Akun dari JSON (data dari API)
  factory Akun.fromJson(Map<String, dynamic> json) {
    return Akun(
      id: json['id'] as int,
      nama: json['nama'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
    );
  }

  // Method untuk mengubah objek Akun menjadi JSON (untuk dikirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      // 'password': password, // Penting: Jangan sertakan password di model jika tidak diperlukan untuk request tertentu
      'role': role,
    };
  }
}
