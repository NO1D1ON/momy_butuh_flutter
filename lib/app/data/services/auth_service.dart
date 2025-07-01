import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momy_butuh_flutter/app/data/models/user_type.dart';
import '../../utils/constants.dart'; // Pastikan path ini benar

class AuthService {
  late http.Client _client;
  final _storage = const FlutterSecureStorage();

  AuthService() {
    _client = http.Client();
    // Untuk web, kita perlu memastikan client dapat menangani cookies.
    // Library http secara default sudah melakukannya di browser modern,
    // namun kita akan membuat perubahan di konfigurasi backend untuk memastikan.
  }

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

    String endpoint = (userType == UserType.babysitter)
        ? '${AppConstants.baseUrl}/babysitter/login'
        : '${AppConstants.baseUrl}/login';

    final url = Uri.parse(endpoint);

    try {
      final response = await _client.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData.containsKey('access_token') &&
            responseData.containsKey('user')) {
          // 1. Simpan Token
          await _storage.write(
            key: 'auth_token',
            value: responseData['access_token'],
          );
          // 2. Simpan Tipe Pengguna
          await _storage.write(
            key: 'user_type',
            value: userType.name,
          ); // Gunakan .name untuk enum

          // 3. (PENTING) Simpan ID Pengguna
          final userId = responseData['user']['id'].toString();
          await _storage.write(key: 'user_id', value: userId);

          return {'success': true, 'data': responseData};
        } else {
          return {
            'success': false,
            'message': 'Respons tidak valid dari server',
          };
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

  // --- METHOD LOGOUT YANG DIPERBAIKI ---
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
        // Abaikan error dari server, yang penting data lokal bersih
        print("Error saat logout di server (diabaikan): $e");
      }
    }

    // Hapus SEMUA data terkait sesi dari penyimpanan lokal
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_type');
    await _storage.delete(key: 'user_id');
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation, // Tambahkan parameter ini
  }) async {
    await _getCsrfCookie();

    final url = Uri.parse('${AppConstants.baseUrl}/register');
    try {
      final response = await _client.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation':
              passwordConfirmation, // Kirim field ini ke API
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Registrasi berhasil. Silakan login.',
        };
      } else {
        String errorMessage = responseData['message'] ?? 'Registrasi gagal.';
        if (responseData.containsKey('errors')) {
          errorMessage =
              (responseData['errors'] as Map<String, dynamic>).values.first[0];
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
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

  Future<String?> getUserType() async {
    return await _storage.read(key: 'user_type');
  }

  Future<Map<String, dynamic>> registerAsBabysitter({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String birthDate,
    required String address,
  }) async {
    // Endpoint registrasi babysitter di backend Anda
    final url = Uri.parse('${AppConstants.baseUrl}/babysitter/register');

    try {
      final response = await _client.post(
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
          // Tambahkan field lain jika diperlukan oleh backend Anda
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // 201 Created
        return {
          'success': true,
          'message':
              responseData['message'] ?? 'Registrasi berhasil. Silakan login.',
        };
      } else {
        // Tangani error validasi dari Laravel
        String errorMessage = 'Terjadi kesalahan.';
        if (responseData.containsKey('errors')) {
          // Ambil pesan error pertama dari daftar error validasi
          errorMessage = responseData['errors'].values.first[0];
        } else if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }
}
