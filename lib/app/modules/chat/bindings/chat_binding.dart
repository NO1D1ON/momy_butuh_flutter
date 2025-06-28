import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/modules/chat/controllers/message_controller.dart';
import '../../../data/services/auth_service.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan semua dependensi yang dibutuhkan oleh ChatController
    Get.lazyPut<http.Client>(() => http.Client());
    Get.lazyPut<AuthService>(() => AuthService());

    Get.lazyPut<ChatController>(
      () => ChatController(
        authService: Get.find<AuthService>(),
        httpClient: Get.find<http.Client>(),
      ),
    );
  }
}
