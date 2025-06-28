import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // <-- 1. Import paket yang benar
import '../../utils/constants.dart';

class TopupService {
  // Buat instance dari secure storage untuk digunakan
  static const _storage = FlutterSecureStorage();

  static Future<bool> submitTopup({
    required Uint8List imageBytes,
    required String fileName,
    required String amount,
  }) async {
    // --- PERBAIKAN DI SINI ---
    // Baca token dari secure storage, bukan dari SharedPreferences
    final token = await _storage.read(key: 'auth_token');
    // --- BATAS PERBAIKAN ---

    final url = Uri.parse('${AppConstants.baseUrl}/topups');

    var request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['amount'] = amount;
    request.files.add(
      http.MultipartFile.fromBytes(
        'payment_proof',
        imageBytes,
        filename: fileName,
      ),
    );

    try {
      final response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
