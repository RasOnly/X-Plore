// lib/services/api_service.dart
import 'dart:convert'; // Untuk encode/decode JSON
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import package http

// Import model-model yang telah Anda buat
import 'package:ras/models/akun.dart';
import 'package:ras/models/wisata.dart';
import 'package:ras/models/penginapan.dart';
import 'package:ras/models/kuliner.dart';
import 'package:ras/models/favorites.dart';

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
  Future<Akun> createAkun({
    required String username,
    required String email,
    required String password,
    required String userRole,
    required String nohp,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/akun'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
        'user_role': userRole,
        'nohp': nohp,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);

      // Jika respons API kamu langsung berupa objek akun:
      if (jsonResponse is Map<String, dynamic>) {
        return Akun.fromJson(jsonResponse);
      }

      // Kalau respons dibungkus dalam field "data" (misal: { "data": {...akun...} })
      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('data')) {
        return Akun.fromJson(jsonResponse['data']);
      }

      throw Exception('Format data akun tidak sesuai.');
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
  // ========================== PENGINAPAN ==========================

  // GET /api/penginapan
  Future<List<Penginapan>> getAllPenginapan() async {
    final response = await http.get(Uri.parse('$_baseUrl/penginapan'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Penginapan.fromJson(data)).toList();
    } else {
      throw Exception(
        'Gagal memuat data penginapan. Status: ${response.statusCode}',
      );
    }
  }

  // GET /api/penginapan/{id}
  Future<Map<String, dynamic>> getPenginapanById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/penginapan/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat detail penginapan.');
    }
  }

  // ========================== KULINER ==========================

  // GET /api/kuliner
  Future<List<dynamic>> getAllKuliner() async {
    final response = await http.get(Uri.parse('$_baseUrl/kuliner'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data kuliner.');
    }
  }

  // GET /api/kuliner/{id}
  Future<Map<String, dynamic>> getKulinerById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/kuliner/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat detail kuliner.');
    }
  }

  // ========================== FAVORIT ==========================

  // GET /api/favoritwisata/{id}
  Future<List<dynamic>> getFavoritWisata(int userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/favoritwisata/$userId'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat favorit wisata.');
    }
  }

  // POST /api/user/wisata/favorites
  Future<void> addFavoritWisata(int userId, int wisataId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/wisata/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'wisata_id': wisataId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan favorit wisata.');
    }
  }

  // DELETE /api/user/{user_id}/wisata/favorites/{wisata_id}
  Future<void> deleteFavoritWisata(int userId, int wisataId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/user/$userId/wisata/favorites/$wisataId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus favorit wisata.');
    }
  }

  // ========================== RATING ==========================

  // POST /api/rating/wisata
  Future<void> createRatingWisata(
    int userId,
    int wisataId,
    double rating,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/rating/wisata'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'wisata_id': wisataId,
        'rating': rating,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal mengirim rating wisata.');
    }
  }

  // GET /api/rating/wisata
  Future<List<dynamic>> getAllRatingWisata() async {
    final response = await http.get(Uri.parse('$_baseUrl/rating/wisata'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat semua rating wisata.');
    }
  }

  // ========================== ULASAN ==========================

  // GET /api/ulasan
  Future<List<dynamic>> getAllUlasan() async {
    final response = await http.get(Uri.parse('$_baseUrl/ulasan'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat ulasan.');
    }
  }
}

class SessionManager {
  static Future<void> saveUserSession({
    required int userId,
    required String username,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('role', role);
  }

  static Future<Map<String, dynamic>> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getInt('user_id'),
      'username': prefs.getString('username'),
      'email': prefs.getString('email'),
      'role': prefs.getString('role'),
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
