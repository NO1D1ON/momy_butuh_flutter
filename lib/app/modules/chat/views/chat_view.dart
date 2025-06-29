// File: lib/app/modules/chat/views/chat_view.dart (Perbaikan)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Sesuaikan path impor dengan struktur proyek Anda
import 'package:momy_butuh_flutter/app/modules/chat/controllers/message_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN: Bungkus seluruh halaman dengan Obx untuk menangani state
    // loading dan error secara menyeluruh sebelum mencoba membangun UI utama.
    return Obx(() {
      // Skenario 1: Sedang memuat data awal
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(title: const Text('Memuat Percakapan...')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      // Skenario 2: Terjadi error saat memuat data
      if (controller.errorMessage.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text('Terjadi Kesalahan')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: ${controller.errorMessage.value}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      // Skenario 3: Data berhasil dimuat, tampilkan UI lengkap
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kode ini sekarang aman karena hanya dieksekusi setelah loading selesai
              Text(controller.otherPartyName),
              // Gunakan Obx hanya untuk widget yang perlu update secara spesifik
              Obx(() {
                if (controller.isOpponentTyping.value) {
                  return const Text(
                    'sedang mengetik...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: Align(
                        alignment: message.isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: message.isMe
                                ? AppTheme.primaryColor.withOpacity(0.8)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.isMe
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      );
    });
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: const InputDecoration(
                hintText: 'Ketik pesan...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: controller.sendMessage,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}
