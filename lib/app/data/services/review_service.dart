import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

class ReviewService {
  // Fungsi untuk mengirim ulasan baru
  static Future<Map<String, dynamic>> postReview({
    required int bookingId,
    required int rating,
    required String comment,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/reviews');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'booking_id': bookingId.toString(),
          'rating': rating.toString(),
          'comment': comment,
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {'message': 'Terjadi kesalahan: $e'};
    }
  }
}
