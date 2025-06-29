import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // <-- 1. Import paket yang benar
import 'package:momy_butuh_flutter/app/data/models/joboffer_model.dart';
import '../../utils/constants.dart';

class JobOfferService {
  // Buat instance dari secure storage untuk digunakan di semua method
  static const _storage = FlutterSecureStorage();

  // Method fetchJobOffers() dengan perbaikan
  static Future<List<JobOffer>> fetchJobOffers() async {
    // --- TAMBAHKAN BAGIAN INI UNTUK MENGAMBIL TOKEN ---
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }
    // --- BATAS PENAMBAHAN ---

    final url = Uri.parse('${AppConstants.baseUrl}/job-offers');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          // --- TAMBAHKAN HEADER AUTENTIKASI ---
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => JobOffer.fromJson(json)).toList();
      } else {
        // Berikan pesan error yang lebih spesifik berdasarkan status code
        throw Exception(
          'Gagal memuat data. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      // Teruskan error agar bisa ditangkap oleh controller
      rethrow;
    }
  }

  // Method createOffer dengan perbaikan
  static Future<Map<String, dynamic>> createOffer(
    Map<String, String> offerData,
  ) async {
    // --- PERBAIKAN DI SINI ---
    // Baca token dari secure storage
    final token = await _storage.read(key: 'auth_token');
    // --- BATAS PERBAIKAN ---

    final url = Uri.parse('${AppConstants.baseUrl}/job-offers');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan token
        },
        body: offerData,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        String errorMessage =
            responseData['message'] ?? 'Gagal mempublikasikan penawaran.';
        if (responseData.containsKey('errors')) {
          errorMessage += '\n' + responseData['errors'].toString();
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }

  static Future<List<JobOffer>> fetchMyJobOffers() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token tidak ditemukan.');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/my-job-offers');
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
        return data.map((json) => JobOffer.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat penawaran saya');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<JobOffer> fetchJobOfferById(int id) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/job-offers/$id');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Langsung parse body jika API mengembalikan objek tunggal
        final Map<String, dynamic> data = json.decode(response.body);
        return JobOffer.fromJson(data);
      } else {
        throw Exception(
          'Gagal memuat detail. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      // Teruskan error agar bisa ditangani di controller
      rethrow;
    }
  }

  /// Menerima (accept) sebuah tawaran pekerjaan.
  static Future<Map<String, dynamic>> acceptJobOffer(int id) async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/job-offers/$id/accept');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return {
        'success': response.statusCode == 200,
        'message':
            json.decode(response.body)['message'] ?? 'Status tidak diketahui',
      };
    } catch (e) {
      rethrow;
    }
  }
}
