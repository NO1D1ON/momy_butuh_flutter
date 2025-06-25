import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:momy_butuh_flutter/app/data/models/message_model.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/echo_service.dart'; // Import service baru
import '../../../data/services/message_service.dart';

class ChatController extends GetxController {
  late final Babysitter babysitter;
  late final EchoService _echoService; // Properti untuk EchoService

  var conversationId = Rxn<int>();
  var messages = <Message>[].obs;
  var isLoading = true.obs;
  final messageTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    babysitter = Get.arguments;
    _echoService = EchoService(); // Buat instance EchoService
    fetchConversation();
  }

  @override
  void onClose() {
    _echoService.disconnect(); // Putuskan koneksi saat keluar dari halaman chat
    super.onClose();
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
        messages.assignAll(messageList.reversed);

        // Setelah mendapatkan ID percakapan, mulai dengarkan channel real-time
        initEcho();
      }
    } finally {
      isLoading(false);
    }
  }

  // Fungsi baru untuk inisialisasi dan mendengarkan broadcast
  void initEcho() async {
    await _echoService.init();
    _echoService.listenToConversation(conversationId.value!, (eventData) {
      // Saat ada event 'MessageSent' masuk, tambahkan pesan baru ke daftar
      final newMessage = Message.fromJson(eventData['message']);
      messages.insert(0, newMessage);
    });
  }

  void sendMessage() async {
    if (messageTextController.text.isEmpty) return;

    final messageBody = messageTextController.text;
    // Optimistic UI: langsung tampilkan pesan di layar dengan status sementara
    // Ini akan kita sempurnakan nanti, untuk sekarang kita fokus pada pengiriman

    // Hapus teks dari input field
    messageTextController.clear();

    try {
      // Tidak perlu state loading di sini agar UI terasa instan
      var result = await MessageService.sendMessage(
        babysitterId: babysitter.id,
        body: messageBody,
      );

      if (!result['success']) {
        // Jika gagal, tampilkan notifikasi error
        AwesomeDialog(
          context: Get.context!,
          dialogType: DialogType.error,
          title: 'Gagal',
          desc: result['message'] ?? 'Tidak dapat mengirim pesan.',
        ).show();
      }
      // Jika berhasil, kita tidak melakukan apa-apa, karena kita akan menunggu pesan datang dari broadcast real-time
    } catch (e) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        title: 'Error',
        desc: e.toString(),
      ).show();
    }
  }
}
