import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/message_service.dart';
import 'package:momy_butuh_flutter/app/modules/conversation_list/controllers/conversation_list_controller.dart';

class ConversationListBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan semua dependensi yang dibutuhkan
    Get.lazyPut<http.Client>(() => http.Client());
    Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<MessageService>(
      () => MessageService(
        authService: Get.find<AuthService>(),
        httpClient: Get.find<http.Client>(),
      ),
    );

    // Daftarkan controller utama modul ini
    Get.lazyPut<ConversationListController>(
      () => ConversationListController(
        messageService: Get.find<MessageService>(),
        authService: Get.find<AuthService>(),
        httpClient: Get.find<http.Client>(),
      ),
    );
  }
}
