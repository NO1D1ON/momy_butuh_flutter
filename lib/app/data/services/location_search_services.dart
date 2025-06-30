import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../utils/constants.dart';

class LocationSearchService {
  static const _storage = FlutterSecureStorage();

  static Future<List<dynamic>> searchPlaces(String query) async {
    final token = await _storage.read(key: 'auth_token');
    final url = Uri.parse(
      '${AppConstants.baseUrl}/location/search?query=$query',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // API Google mengembalikan 'predictions', kita teruskan saja
        return json.decode(response.body)['predictions'];
      } else {
        throw Exception('Gagal mencari lokasi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final token = await _storage.read(key: 'auth_token');
    final url = Uri.parse(
      '${AppConstants.baseUrl}/location/details?place_id=$placeId',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // API Google mengembalikan 'result', kita teruskan
        return json.decode(response.body)['result'];
      } else {
        throw Exception('Gagal mendapatkan detail lokasi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
