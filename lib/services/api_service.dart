// lib/services/api_service.dart
import 'dart:convert'; // Untuk encode/decode JSON
import 'package:http/http.dart' as http; // Import package http

// Import model-model yang telah Anda buat
import 'package:ras/models/akun.dart';
import 'package:ras/models/wisata.dart';
// ... import model-model lainnya

class ApiService {
  // Ganti ini dengan Base URL API Cloud Run Anda
  final String _baseUrl =
      'https://xplore-app-328588022038.asia-southeast2.run.app/api';

  // --- Contoh Fungsi untuk Endpoint Akun ---

  // Mengambil semua akun (GET /api/akun)
  Future<List<Akun>> getAllAkun() async {
    final response = await http.get(Uri.parse('$_baseUrl/akun'));

    if (response.statusCode == 200) {
      // Jika server mengembalikan respons 200 OK, parse JSON
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((akun) => Akun.fromJson(akun)).toList();
    } else {
      // Jika respons bukan 200 OK, lempar exception
      throw Exception(
        'Failed to load accounts. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // Membuat akun baru (POST /api/akun)
  Future<Akun> createAkun(
    String nama,
    String email,
    String password,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/akun'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nama': nama,
        'email': email,
        'password': password, // Kirim password saat membuat akun
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      // 201 Created
      return Akun.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to create account. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // Login User (POST /api/loginuser)
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/loginuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Asumsi backend mengembalikan data user dan/atau token
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to login. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // --- Contoh Fungsi untuk Endpoint Wisata ---

  // Mengambil semua wisata (GET /api/wisata)
  Future<List<Wisata>> getAllWisata() async {
    final response = await http.get(Uri.parse('$_baseUrl/wisata'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Wisata.fromJson(data)).toList();
    } else {
      throw Exception(
        'Failed to load wisata. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // Mengambil detail wisata berdasarkan ID (GET /api/wisatadetail/{id})
  Future<Wisata> getWisataDetailById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/wisatadetail/$id'));

    if (response.statusCode == 200) {
      return Wisata.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load wisata detail. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // ... Tambahkan fungsi-fungsi lain untuk setiap rute yang Anda miliki di routes.go
  // Misalnya: createWisata, updateWisata, deleteWisata, getAllKuliner, createTransaksi, dll.
}
