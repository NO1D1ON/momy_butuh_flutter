import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momy_butuh_flutter/app/data/models/babysitter_availibility_model.dart';
import '../../utils/constants.dart';

class BabysitterAvailabilityService {
  static const _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> createAvailability(
    Map<String, String> data,
  ) async {
    final token = await _storage.read(key: 'auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/babysitter/availabilities');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Tambahkan content type
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data), // Encode sebagai JSON
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        if (response.statusCode == 422 && responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first[0];
          return {'success': false, 'message': firstError};
        }
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal mempublikasikan jadwal',
        };
      }
    } catch (e) {
      print('Error in createAvailability: $e');
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<List<BabysitterAvailability>> fetchAvailabilities() async {
    final url = Uri.parse('${AppConstants.baseUrl}/babysitter-availabilities');

    try {
      print('Fetching availabilities from: $url');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody.isEmpty) {
          print('Empty response body');
          return [];
        }

        final dynamic decodedData = json.decode(responseBody);

        if (decodedData is! List) {
          print('Response is not a list: ${decodedData.runtimeType}');
          // Jika response adalah object dengan error
          if (decodedData is Map && decodedData.containsKey('error')) {
            throw Exception(decodedData['message'] ?? 'Server error');
          }
          throw Exception('Format response tidak valid');
        }

        final List<dynamic> data = decodedData;

        return data
            .map((json) {
              try {
                return BabysitterAvailability.fromJson(json);
              } catch (e) {
                print('Error parsing item: $e');
                print('Item data: $json');
                return null;
              }
            })
            .where((item) => item != null)
            .cast<BabysitterAvailability>()
            .toList();
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Error body: ${response.body}');

        // Coba parse error message dari response
        try {
          final errorData = json.decode(response.body);
          final errorMessage =
              errorData['message'] ?? errorData['error'] ?? 'Gagal memuat data';
          throw Exception(errorMessage);
        } catch (parseError) {
          throw Exception('Server error: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Exception in fetchAvailabilities: $e');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException')) {
        throw Exception(
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        );
      }
      rethrow;
    }
  }
}
