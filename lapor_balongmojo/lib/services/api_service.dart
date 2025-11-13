import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lapor_balongmojo/models/laporan_model.dart';
import 'package:lapor_balongmojo/models/berita_model.dart';
import 'package:lapor_balongmojo/services/secure_storage_service.dart';

class ApiService {
  // 10.0.2.2 adalah localhost untuk Android Emulator
  // Ganti ke IP asli Anda (cth: 192.168.1.5:3000) jika tes di device fisik
  static const String _baseUrl = 'http://10.0.2.2:3000';

  final SecureStorageService _storageService = SecureStorageService();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storageService.readToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // --- AUTH ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<void> registerMasyarakat(
      String nama, String email, String noTelp, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register/masyarakat'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'nama_lengkap': nama,
        'email': email,
        'no_telepon': noTelp,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // --- LAPORAN ---
  Future<List<LaporanModel>> getLaporan() async {
    final headers = await _getAuthHeaders();
    final response =
        await http.get(Uri.parse('$_baseUrl/laporan'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => LaporanModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat laporan');
    }
  }

  Future<void> postLaporan(String judul, String deskripsi) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/laporan'),
      headers: headers,
      body: jsonEncode({'judul': judul, 'deskripsi': deskripsi}),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<void> updateStatusLaporan(int id, String status) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/laporan/$id'),
      headers: headers,
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // --- BERITA ---
  Future<List<BeritaModel>> getBerita() async {
    final response = await http.get(Uri.parse('$_baseUrl/berita'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => BeritaModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat berita');
    }
  }
  
  Future<void> postBerita(String judul, String isi) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/berita'),
      headers: headers,
      body: jsonEncode({'judul': judul, 'isi': isi}),
    );
     if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  // --- ADMIN (PERANGKAT) ---
  Future<List<dynamic>> getPendingUsers() async {
     final headers = await _getAuthHeaders();
     final response =
        await http.get(Uri.parse('$_baseUrl/admin/users-pending'), headers: headers);
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else {
      throw Exception('Gagal memuat user pending');
    }
  }

  Future<void> verifikasiUser(int userId) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$_baseUrl/admin/verifikasi/$userId'),
      headers: headers
    );
     if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}