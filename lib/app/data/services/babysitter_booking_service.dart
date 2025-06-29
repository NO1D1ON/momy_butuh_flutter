import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import '../../utils/constants.dart';

class BabysitterBookingService {
  static const _storage = FlutterSecureStorage();

  /// Mengambil semua booking milik babysitter yang sedang login
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
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat riwayat booking');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  /// Mengirim konfirmasi bahwa babysitter telah menyelesaikan booking
  static Future<Map<String, dynamic>> babysitterConfirmBooking(
    int bookingId,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    final url = Uri.parse(
      '${AppConstants.baseUrl}/bookings/$bookingId/babysitter-confirm',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal mengkonfirmasi',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
