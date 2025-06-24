import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

// Kelas ini bertanggung jawab untuk semua panggilan API terkait otentikasi.
class AuthService {
  // Fungsi untuk mengirim permintaan login ke API
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${AppConstants.baseUrl}/login');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Jika login berhasil (status 200 OK)
        return {'success': true, 'data': responseData};
      } else {
        // Jika gagal, kembalikan pesan error dari server
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      // Tangani error koneksi atau lainnya
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
