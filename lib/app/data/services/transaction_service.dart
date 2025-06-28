import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // <-- 1. Import paket yang benar
import '../../utils/constants.dart';
import '../models/transaction_model.dart';

class TransactionService {
  // Buat instance dari secure storage untuk digunakan
  static const _storage = FlutterSecureStorage();

  static Future<List<Transaction>> getTransactionHistory() async {
    // --- PERBAIKAN DI SINI ---
    // Baca token dari secure storage, bukan dari SharedPreferences
    final token = await _storage.read(key: 'auth_token');
    // --- BATAS PERBAIKAN ---

    final url = Uri.parse('${AppConstants.baseUrl}/transactions');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat riwayat transaksi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
