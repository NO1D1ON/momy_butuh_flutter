import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import 'package:momy_butuh_flutter/app/data/models/user_model.dart';
import '../../utils/constants.dart';

class BookingService {
  static const _storage = FlutterSecureStorage();

  // ... (fungsi createBooking, getMyBookings, completeBooking, fetchParentProfileById tetap sama) ...
  static Future<Map<String, dynamic>> createBooking({
    required int babysitterId,
    required String bookingDate,
    required String startTime,
    required String endTime,
  }) async {
    final token = await _storage.read(key: 'auth_token');
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

  static Future<List<Booking>> getMyBookings() async {
    final token = await _storage.read(key: 'auth_token');
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
    final token = await _storage.read(key: 'auth_token');
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
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal menyelesaikan booking',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }

  static Future<UserModel> fetchParentProfileById(int userId) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token tidak ditemukan.');
    }
    final url = Uri.parse('${AppConstants.baseUrl}/parents/$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception(
          'Gagal memuat profil pemesan. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // --- FUNGSI BARU UNTUK KONFIRMASI DARI ORANG TUA ---
  static Future<Map<String, dynamic>> parentConfirmBooking(
    int bookingId,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      return {'success': false, 'message': 'Otentikasi gagal.'};
    }

    // Endpoint ini harus Anda buat di backend (routes/api.php)
    final url = Uri.parse(
      '${AppConstants.baseUrl}/bookings/$bookingId/parent-confirm',
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
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal mengkonfirmasi pesanan',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }
}
