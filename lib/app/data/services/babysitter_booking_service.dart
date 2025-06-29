import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import '../../utils/constants.dart';

class BabysitterBookingService {
  static const _storage = FlutterSecureStorage();

  static Future<List<Booking>> getMyBookings() async {
    final token = await _storage.read(key: 'auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/babysitter/my-bookings');

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
        // Anda mungkin perlu menyesuaikan Booking.fromJson jika struktur datanya berbeda
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat riwayat booking');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
