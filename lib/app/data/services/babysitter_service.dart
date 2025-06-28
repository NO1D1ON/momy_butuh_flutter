import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/babysitter_model.dart';
import '../../utils/constants.dart';

class BabysitterService {
  // Fungsi untuk mengambil semua data babysitter dari API
  static Future<List<Babysitter>> fetchBabysitters() async {
    final url = Uri.parse('${AppConstants.baseUrl}/babysitters');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        // Jika gagal, kembalikan list kosong
        print('Gagal memuat data babysitter: ${response.body}');
        return [];
      }
    } catch (e) {
      // Jika terjadi kesalahan koneksi, kembalikan list kosong
      print('Terjadi kesalahan saat fetchBabysitters: $e');
      return [];
    }
  }

  // Fungsi untuk mengambil detail satu babysitter berdasarkan ID
  // Mengembalikan Future<Babysitter?> (nullable) untuk menangani kasus data tidak ditemukan.
  static Future<Babysitter?> fetchBabysitterDetail(int id) async {
    final url = Uri.parse('${AppConstants.baseUrl}/babysitters/$id');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // PASTIKAN MENGAMBIL DARI KUNCI 'data'
        final Map<String, dynamic> data = responseData['data'];
        return Babysitter.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Gagal memuat detail: ${errorData['message']}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  static Future<List<Babysitter>> fetchNearbyBabysitters(
    double lat,
    double lon,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse(
      '${AppConstants.baseUrl}/babysitters/nearby?latitude=$lat&longitude=$lon',
    );

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
        return data.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        print('Gagal memuat data babysitter terdekat: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Terjadi kesalahan saat fetchNearbyBabysitters: $e');
      return [];
    }
  }

  static Future<List<Babysitter>> searchBabysitters(String name) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}/babysitters/search?name=$name',
    );
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        print('Gagal mencari babysitter: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Terjadi kesalahan saat searchBabysitters: $e');
      return [];
    }
  }
}
