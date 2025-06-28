import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/conversation_list/controllers/conversation_list_controller.dart';

class ConversationListView extends GetView<ConversationListController> {
  const ConversationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchConversations(),
          ),
        ],
      ),
      body: Obx(() {
        // Bungkus dengan Obx untuk reaktivitas
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.conversationList.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada percakapan.\nMulai obrolan baru!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.conversationList.length,
          itemBuilder: (context, index) {
            final conversation = controller.conversationList[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(conversation.otherPartyName.substring(0, 1)),
              ),
              title: Text(conversation.otherPartyName),
              subtitle: Text(
                conversation.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(conversation.lastMessageTime),
              onTap: () => controller.navigateToChat(conversation),
            );
          },
        );
      }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => controller.navigateToNewChat(),
      //   tooltip: 'Mulai Obrolan Baru',
      //   child: const Icon(Icons.add_comment_rounded),
      // ),
    );
  }
}
