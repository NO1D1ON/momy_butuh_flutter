import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

class FavoriteService {
  // Method untuk mengambil daftar babysitter yang sudah difavoritkan oleh user
  static Future<List<Babysitter>> getFavorites() async {
    // Mengambil token autentikasi dari penyimpanan lokal
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Jika token tidak ada, kembalikan list kosong karena user belum login
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali.');
    }

    // Tentukan URL endpoint untuk mengambil data favorit
    final url = Uri.parse(
      '${AppConstants.baseUrl}/favorites',
    ); // Sesuaikan endpoint jika berbeda

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan token untuk autentikasi
        },
      );

      if (response.statusCode == 200) {
        // Jika berhasil, decode JSON response
        // Asumsi API mengembalikan list data di dalam key 'data'
        final List<dynamic> responseData = json.decode(response.body)['data'];

        // Ubah setiap item JSON menjadi objek Babysitter dan kembalikan sebagai list
        return responseData.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        // Jika server merespon dengan status error, lempar exception
        throw Exception('Gagal memuat data favorit dari server.');
      }
    } catch (e) {
      // Jika terjadi error koneksi atau lainnya, lempar exception
      throw Exception('Terjadi kesalahan saat mengambil data favorit: $e');
    }
  }

  // Fungsi untuk mendapatkan daftar ID favorit saat halaman dimuat
  static Future<List<int>> getFavoriteIds() async {
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
        // API Laravel kita mengembalikan list of integers
        final List<dynamic> data = json.decode(response.body);
        return data.map((id) => id as int).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
