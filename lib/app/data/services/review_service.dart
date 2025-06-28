import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // <-- 1. Import paket yang benar
import '../../utils/constants.dart';

class ReviewService {
  // Buat instance dari secure storage untuk digunakan
  static const _storage = FlutterSecureStorage();

  // Fungsi untuk mengirim ulasan baru
  static Future<Map<String, dynamic>> postReview({
    required int bookingId,
    required int rating,
    required String comment,
  }) async {
    // --- PERBAIKAN DI SINI ---
    // Baca token dari secure storage
    final token = await _storage.read(key: 'auth_token');
    // --- BATAS PERBAIKAN ---

    final url = Uri.parse('${AppConstants.baseUrl}/reviews');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan token
        },
        body: {
          'booking_id': bookingId.toString(),
          'rating': rating.toString(),
          'comment': comment,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // 201 Created
        return {
          'success': true,
          'message': responseData['message'] ?? 'Ulasan berhasil dikirim.',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal mengirim ulasan.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
