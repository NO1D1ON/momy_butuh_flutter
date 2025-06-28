import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Ganti dari SharedPreferences
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import '../../utils/constants.dart';

class FavoriteService {
  // Gunakan FlutterSecureStorage untuk keamanan token
  static const _storage = FlutterSecureStorage();

  // Ambil daftar babysitter favorit (full data)
  static Future<List<Babysitter>> getFavorites() async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali.');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/favorites');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Bisa berbentuk langsung list atau data wrapper
        final data = responseData is List
            ? responseData
            : responseData['data'] as List<dynamic>;

        return data.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data favorit dari server.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data favorit: $e');
    }
  }

  // Ambil hanya ID favorit (misalnya untuk perbandingan cepat)
  static Future<List<int>> getFavoriteIds() async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) return [];

    final url = Uri.parse('${AppConstants.baseUrl}/favorites');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded is List ? decoded : decoded['data'];
        return data.map((id) => id as int).toList();
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  // Toggle favorite
  static Future<Map<String, dynamic>> toggleFavorite(int babysitterId) async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      return {
        'success': false,
        'message': 'Anda harus login untuk menggunakan fitur ini.',
      };
    }

    final url = Uri.parse('${AppConstants.baseUrl}/favorites/$babysitterId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Berhasil'};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Sesi Anda telah berakhir, silakan login kembali.',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengubah status favorit.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi.'};
    }
  }
}
