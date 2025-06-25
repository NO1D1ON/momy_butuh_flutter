import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

// Kelas ini bertanggung jawab untuk semua panggilan API terkait otentikasi.
class AuthService {
  static final _client = http.Client(); // Gunakan satu instance client

  // Fungsi untuk mengambil CSRF cookie
  static Future<void> getCsrfCookie() async {
    final url = Uri.parse(
      '${AppConstants.baseUrl.replaceFirst('/api', '')}/sanctum/csrf-cookie',
    );
    try {
      await _client.get(url);
      print("CSRF Cookie has been set.");
    } catch (e) {
      print("Error fetching CSRF cookie: $e");
    }
  }

  // METHOD LOGIN YANG DIPERBAIKI
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    // 1. Panggil fungsi untuk mendapatkan cookie terlebih dahulu
    await getCsrfCookie();

    final url = Uri.parse('${AppConstants.baseUrl}/login');
    try {
      final response = await _client.post(
        // Gunakan _client
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Fungsi untuk mengirim permintaan registrasi ke API
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('${AppConstants.baseUrl}/register');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        // Jika registrasi berhasil (status 201 Created)
        return {
          'success': true,
          'message': 'Registrasi berhasil. Silakan login.',
        };
      } else {
        // Tangani jika email sudah terdaftar atau error validasi lainnya
        final responseData = json.decode(response.body);
        return {'success': false, 'message': responseData.toString()};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Jika tidak ada token, langsung kembalikan pesan gagal
    if (token == null) {
      return {'success': false, 'message': 'Token tidak ditemukan.'};
    }

    final url = Uri.parse('${AppConstants.baseUrl}/user');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData};
      } else {
        // Termasuk jika token sudah tidak valid (status 401)
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal memuat profil',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      final url = Uri.parse('${AppConstants.baseUrl}/logout');
      try {
        await http.post(
          url,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        // Abaikan error saat logout di server, yang terpenting token lokal dihapus
      }
    }

    // Selalu hapus token dari penyimpanan lokal
    await prefs.remove('auth_token');
  }
}
