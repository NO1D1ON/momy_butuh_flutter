import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/chat/controllers/message_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
