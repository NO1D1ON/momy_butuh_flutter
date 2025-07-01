import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import '../../utils/constants.dart';

class FavoriteService {
  static const _storage = FlutterSecureStorage();

  /// Mengambil daftar lengkap profil babysitter yang telah difavoritkan.
  static Future<List<Babysitter>> getFavorites() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Otentikasi dibutuhkan. Silakan login kembali.');
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
        // PERBAIKAN UTAMA DI SINI
        // 1. Decode JSON menjadi dynamic, bisa Map atau List
        final dynamic responseData = json.decode(response.body);

        // 2. Cek apakah hasil decode adalah List atau Map yang berisi 'data'
        final List<dynamic> data;
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          data = responseData['data'] as List<dynamic>;
        } else {
          // Jika format tidak dikenali, lempar error
          throw Exception('Format data favorit tidak sesuai.');
        }

        // 3. Lanjutkan proses seperti biasa
        return data.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data favorit dari server.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data favorit: $e');
    }
  }

  /// Mengambil HANYA daftar ID dari babysitter yang difavoritkan.
  static Future<List<int>> getFavoriteIds() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return [];

    final url = Uri.parse('${AppConstants.baseUrl}/favorites/ids');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((id) => id as int).toList();
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  /// Menambah atau menghapus babysitter dari daftar favorit.
  static Future<Map<String, dynamic>> toggleFavorite(int babysitterId) async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null) {
      return {
        'success': false,
        'message': 'Anda harus login untuk menggunakan fitur ini.',
      };
    }

    // Gunakan endpoint yang sesuai dengan yang Anda definisikan di backend
    final url = Uri.parse(
      '${AppConstants.baseUrl}/favorites/$babysitterId/toggle',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'message': data['message'] ?? 'Status favorit berhasil diubah.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi. Silakan coba lagi.',
      };
    }
  }
}
