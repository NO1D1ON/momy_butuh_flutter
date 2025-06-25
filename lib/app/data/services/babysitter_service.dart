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
        throw Exception('Gagal memuat data babysitter');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mengambil detail satu babysitter berdasarkan ID
  static Future<Babysitter> fetchBabysitterDetail(int id) async {
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
        throw Exception('Gagal memuat data babysitter');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<List<Babysitter>> fetchNearbyBabysitters(
    double lat,
    double lon,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Pastikan URL dan query parameter sudah benar
    final url = Uri.parse(
      '${AppConstants.baseUrl}/babysitters/nearby?latitude=$lat&longitude=$lon',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization':
              'Bearer $token', // Sertakan token jika rute ini terproteksi
        },
      );

      if (response.statusCode == 200) {
        // Karena API kita mengembalikan list langsung (tanpa kunci 'data' untuk endpoint ini)
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Babysitter.fromJson(json)).toList();
      } else {
        // Jika status bukan 200, lempar error agar bisa ditangkap oleh controller
        throw Exception('Gagal memuat data babysitter terdekat');
      }
    } catch (e) {
      // Jika terjadi error koneksi atau parsing, lempar kembali error tersebut
      // agar bisa ditangani oleh Get.snackbar di controller
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
