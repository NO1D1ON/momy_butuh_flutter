import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class BabysitterAuthService {
  // Fungsi untuk login babysitter
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${AppConstants.baseUrl}/babysitter/login');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );
      return json.decode(response.body);
    } catch (e) {
      return {'message': 'Terjadi kesalahan: $e'};
    }
  }

  // METHOD BARU untuk registrasi babysitter
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String birthDate,
    required String address,
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/babysitter/register');
    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone_number': phoneNumber,
          'birth_date': birthDate,
          'address': address,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        // Menggabungkan pesan error validasi jika ada
        String errorMessage = responseData['message'] ?? 'Registrasi gagal.';
        if (responseData.containsKey('errors')) {
          errorMessage += '\n' + responseData['errors'].toString();
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
