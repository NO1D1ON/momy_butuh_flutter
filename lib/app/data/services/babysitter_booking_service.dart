import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import '../../utils/constants.dart';

class BabysitterBookingService {
  static const _storage = FlutterSecureStorage();

  /// Mengambil semua booking yang terkait dengan babysitter yang login
  static Future<List<Booking>> getMyBookings() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) throw Exception("Token tidak ditemukan.");

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

  /// Mengirim konfirmasi penyelesaian dari sisi Babysitter
  static Future<Map<String, dynamic>> babysitterConfirmBooking(
    int bookingId,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null)
      return {'success': false, 'message': 'Otentikasi gagal.'};

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
        // KEMBALIKAN SELURUH DATA, BUKAN HANYA MESSAGE
        return {'success': true, 'data': responseData};
      } else {
        // Jika gagal, kembalikan pesan error dari server
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal mengkonfirmasi',
        };
      }
    } catch (e) {
      // Jika terjadi error koneksi
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
