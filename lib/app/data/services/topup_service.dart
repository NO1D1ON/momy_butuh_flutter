import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

class TopupService {
  static Future<bool> submitTopup({
    required Uint8List imageBytes,
    required String fileName,
    required String amount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
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
