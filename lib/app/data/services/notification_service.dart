import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momy_butuh_flutter/app/data/models/notification_model.dart';
import 'package:momy_butuh_flutter/app/utils/constants.dart';

class NotificationService {
  static const _storage = FlutterSecureStorage();

  static Future<List<AppNotification>> getNotifications() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Otentikasi dibutuhkan.');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/notifications');
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
        return data.map((json) => AppNotification.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat notifikasi.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  static Future<void> markAsRead(int notificationId) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) return;

    final url = Uri.parse(
      '${AppConstants.baseUrl}/notifications/$notificationId/mark-as-read',
    );
    try {
      await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print("Gagal menandai notifikasi sebagai terbaca: $e");
    }
  }
}
