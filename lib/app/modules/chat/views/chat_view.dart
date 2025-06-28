import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/chat/controllers/message_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Gunakan Column untuk menampilkan title dan typing indicator (subtitle)
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.babysitter.name),
              if (controller.isOpponentTyping.value)
                const Text(
                  'sedang mengetik...',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        }
        return Column(
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
                                ? AppTheme.primaryColor
                                : Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(message.text),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        );
      }),
    );
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
