import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/joboffer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

class JobOfferService {
  // Method fetchJobOffers() biarkan seperti sebelumnya
  static Future<List<JobOffer>> fetchJobOffers() async {
    final url = Uri.parse('${AppConstants.baseUrl}/job-offers');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Ubah setiap item JSON menjadi objek JobOffer
        return data.map((json) => JobOffer.fromJson(json)).toList();
      } else {
        // Jika gagal, lempar error
        throw Exception('Gagal memuat data penawaran pekerjaan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // --- METHOD BARU UNTUK MENGIRIM PENAWARAN ---
  static Future<Map<String, dynamic>> createOffer(
    Map<String, String> offerData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/job-offers');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: offerData, // Kirim data penawaran sebagai body
      );

      final responseData = json.decode(response.body);

      // Status 201 berarti 'Created' (berhasil dibuat)
      if (response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        // Jika ada error validasi dari Laravel, tampilkan pesannya
        String errorMessage =
            responseData['message'] ?? 'Gagal mempublikasikan penawaran.';
        if (responseData.containsKey('errors')) {
          errorMessage += '\n' + responseData['errors'].toString();
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }
}
