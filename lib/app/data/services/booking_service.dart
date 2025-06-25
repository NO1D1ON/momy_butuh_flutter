import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

class BookingService {
  static Future<Map<String, dynamic>> createBooking({
    required int babysitterId,
    required String bookingDate,
    required String startTime,
    required String endTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse('${AppConstants.baseUrl}/bookings');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'babysitter_id': babysitterId.toString(),
          'booking_date': bookingDate,
          'start_time': startTime,
          'end_time': endTime,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal membuat booking',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // METHOD YANG DIPERBAIKI
  static Future<List<Booking>> getMyBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse('${AppConstants.baseUrl}/my-bookings');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Langsung decode sebagai List karena API Laravel mengirimkan array langsung
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat riwayat booking');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<Map<String, dynamic>> completeBooking(int bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    // Pastikan rute ini sesuai dengan yang ada di routes/api.php Laravel
    final url = Uri.parse(
      '${AppConstants.baseUrl}/bookings/$bookingId/complete',
    );

    try {
      final response = await http.patch(
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
        // Jika gagal, kembalikan pesan error dari server
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal menyelesaikan booking',
        };
      }
    } catch (e) {
      // Jika terjadi error koneksi
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }
}
