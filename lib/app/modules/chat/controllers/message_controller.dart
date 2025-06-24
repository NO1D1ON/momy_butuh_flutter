import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/message_model.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/message_service.dart';

class ChatController extends GetxController {
  late final Babysitter babysitter;
  var conversationId = Rxn<int>();
  var messages = <Message>[].obs;
  var isLoading = true.obs;
  final messageTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    babysitter = Get.arguments;
    fetchConversation();
  }

  void fetchConversation() async {
    try {
      isLoading(true);
      var result = await MessageService.getConversation(babysitter.id);
      if (result['success']) {
        conversationId.value = result['data']['id'];
        final messageList = (result['data']['messages'] as List)
            .map((msg) => Message.fromJson(msg))
            .toList();
        messages.assignAll(
          messageList.reversed,
        ); // Balik urutan agar pesan terbaru di bawah
      }
    } finally {
      isLoading(false);
    }
  }

  void sendMessage() async {
    if (messageTextController.text.isEmpty) return;

    final messageBody = messageTextController.text;
    messageTextController.clear();

    var result = await MessageService.sendMessage(
      babysitterId: babysitter.id,
      body: messageBody,
    );

    if (result['success']) {
      final newMessage = Message.fromJson(result['data']);
      messages.insert(
        0,
        newMessage,
      ); // Tambahkan pesan baru di paling atas (karena list dibalik)
    } else {
      Get.snackbar("Error", "Gagal mengirim pesan");
    }
  }
}
