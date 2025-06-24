import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/conversation_list_controller.dart';

class ConversationListView extends GetView<ConversationListController> {
  const ConversationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesan'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.conversationList.isEmpty) {
          return const Center(child: Text('Anda belum memulai percakapan.'));
        }
        return ListView.separated(
          itemCount: controller.conversationList.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final conversation = controller.conversationList[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(conversation.babysitterName.substring(0, 1)),
              ),
              title: Text(
                conversation.babysitterName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Klik untuk melihat pesan..."),
              onTap: () {
                // Logika untuk navigasi ke halaman chat detail akan ditambahkan nanti
                // Get.toNamed(Routes.CHAT, arguments: ...);
              },
            );
          },
        );
      }),
    );
  }
}
