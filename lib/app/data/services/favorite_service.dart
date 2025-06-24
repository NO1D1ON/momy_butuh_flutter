import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

class FavoriteService {
  // Fungsi untuk menambah/menghapus favorit
  static Future<Map<String, dynamic>> toggleFavorite(int babysitterId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/favorites/$babysitterId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<List<Babysitter>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
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
        // --- PERUBAHAN DI SINI ---
        // 1. Decode response body menjadi sebuah Map (objek)
        final Map<String, dynamic> responseData = json.decode(response.body);
        // 2. Ambil list dari dalam kunci 'data'
        final List<dynamic> data = responseData['data'];
        // --- BATAS PERUBAHAN ---

        return data.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data favorit');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
