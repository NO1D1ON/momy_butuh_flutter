import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // <-- 1. Import paket yang benar
import '../models/babysitter_model.dart';
import '../../utils/constants.dart';

class BabysitterService {
  // Buat instance dari secure storage untuk digunakan di semua method
  static const _storage = FlutterSecureStorage();

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
        throw Exception('Gagal memuat data babysitter');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  // Fungsi untuk mengambil detail satu babysitter berdasarkan ID
  static Future<Babysitter?> fetchBabysitterDetail(int id) async {
    final url = Uri.parse('${AppConstants.baseUrl}/babysitters/$id');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
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

  // --- METHOD YANG DIPERBAIKI ---
  static Future<List<Babysitter>> fetchNearbyBabysitters(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}/babysitters/nearby?latitude=$lat&longitude=$lon',
    );

    try {
      // Rute ini bersifat publik, jadi tidak perlu token
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        // API kita mengembalikan { "data": [...] }
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data babysitter terdekat');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  static Future<List<Babysitter>> searchBabysitters(String keyword) async {
    // Jika keyword kosong, kembalikan list kosong
    if (keyword.isEmpty) {
      return [];
    }

    final url = Uri.parse(
      '${AppConstants.baseUrl}/babysitters/search?keyword=$keyword',
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
        throw Exception('Gagal mencari babysitter');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
