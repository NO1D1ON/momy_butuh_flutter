// File: lib/app/data/services/message_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/conversation_model.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/utils/constants.dart';
// Impor model lain yang mungkin Anda perlukan, seperti Message
// import '../models/message_model.dart';

class MessageService {
  // PERBAIKAN: Dependensi akan di-inject melalui konstruktor
  final AuthService _authService;
  final http.Client _httpClient;

  MessageService({
    required AuthService authService,
    required http.Client httpClient,
  }) : _authService = authService,
       _httpClient = httpClient;

  /// Mengambil daftar semua percakapan untuk pengguna yang sedang login.
  Future<List<Conversation>> getConversations() async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final url = Uri.parse('${AppConstants.baseUrl}/conversations');
    try {
      final response = await _httpClient.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat daftar percakapan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  /// Memulai percakapan baru atau mendapatkan yang sudah ada.
  /// Menggantikan metode getConversation yang lama.
  Future<Map<String, dynamic>> initiateConversation(int babysitterId) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final url = Uri.parse('${AppConstants.baseUrl}/conversations/initiate');
    final response = await _httpClient.post(
      // Pastikan menggunakan POST
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'babysitter_id': babysitterId}), // Kirim body
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Gagal memulai sesi percakapan. Status: ${response.statusCode}',
      );
    }
  }

  /// Mengirim pesan baru ke sebuah percakapan.
  Future<Map<String, dynamic>> sendMessage({
    required int receiverId,
    required String body,
  }) async {
    final token = await _authService.getToken();
    if (token == null) throw Exception('Token tidak ditemukan.');

    final url = Uri.parse('${AppConstants.baseUrl}/messages');
    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // PERBAIKAN: Gunakan 'receiver_id' agar konsisten dengan backend
        body: jsonEncode({'receiver_id': receiverId, 'body': body}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {'success': false, 'message': 'Gagal mengirim pesan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
