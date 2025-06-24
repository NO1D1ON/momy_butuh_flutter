import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
