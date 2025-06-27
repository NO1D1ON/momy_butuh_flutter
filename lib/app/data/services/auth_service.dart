import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momy_butuh_flutter/app/data/models/user_type.dart';
import '../../utils/constants.dart'; // Pastikan path ini benar

class AuthService {
  final http.Client _client = http.Client();
  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<void> _deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<void> _getCsrfCookie() async {
    final url = Uri.parse(
      '${AppConstants.baseUrl.replaceFirst('/api', '')}/sanctum/csrf-cookie',
    );
    try {
      await _client.get(url);
      print("CSRF Cookie has been set.");
    } catch (e) {
      print("Error fetching CSRF cookie: $e");
    }
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password,
    UserType userType,
  ) async {
    await _getCsrfCookie();

    // Tentukan endpoint berdasarkan tipe pengguna
    String endpoint;
    if (userType == UserType.babysitter) {
      endpoint = '${AppConstants.baseUrl}/babysitter/login';
    } else {
      endpoint = '${AppConstants.baseUrl}/login';
    }

    final url = Uri.parse(endpoint);

    try {
      final response = await _client.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData.containsKey('access_token')) {
          await _saveToken(responseData['access_token']);
          // Simpan juga tipe pengguna agar kita tahu siapa yang login
          await _storage.write(key: 'user_type', value: userType.toString());
          return {'success': true, 'data': responseData};
        } else {
          return {'success': false, 'message': 'Token tidak ditemukan'};
        }
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      final url = Uri.parse('${AppConstants.baseUrl}/logout');
      try {
        await _client.post(
          url,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        print(
          "Error during server logout, proceeding to delete local token. Error: $e",
        );
      }
    }

    await _deleteToken();
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    await _getCsrfCookie();

    final url = Uri.parse('${AppConstants.baseUrl}/register');
    try {
      final response = await _client.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'name': name, 'email': email, 'password': password},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Registrasi berhasil. Silakan login.',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? responseData.toString(),
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();

    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan. Silakan login kembali.',
      };
    }

    final url = Uri.parse('${AppConstants.baseUrl}/user');
    try {
      final response = await _client.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal memuat profil',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }
}
