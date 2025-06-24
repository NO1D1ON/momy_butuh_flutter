import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/conversation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
// import '../models/message_model.dart';

class MessageService {
  // Fungsi untuk mendapatkan/membuat percakapan beserta isinya
  static Future<Map<String, dynamic>> getConversation(int babysitterId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse(
      '${AppConstants.baseUrl}/conversation/with/$babysitterId',
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
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {'success': false, 'message': 'Gagal memuat percakapan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Fungsi untuk mengirim pesan baru
  static Future<Map<String, dynamic>> sendMessage({
    required int babysitterId,
    required String body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse('${AppConstants.baseUrl}/messages');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'babysitter_id': babysitterId.toString(), 'body': body},
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

  static Future<List<Conversation>> getConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse('${AppConstants.baseUrl}/conversations');
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
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat daftar percakapan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
