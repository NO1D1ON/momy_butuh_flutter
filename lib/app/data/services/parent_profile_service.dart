import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/services/user_profile_model.dart';
import '../../utils/constants.dart';

class ParentProfileService {
  static const _storage = FlutterSecureStorage();

  // Fungsi untuk mengambil detail satu Orang Tua berdasarkan ID
  static Future<UserProfile> fetchParentProfile(int parentId) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Anda harus login sebagai Babysitter.');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/parents/$parentId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // API mengembalikan satu objek user
        final Map<String, dynamic> data = json.decode(response.body);
        return UserProfile.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail pemesan.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
