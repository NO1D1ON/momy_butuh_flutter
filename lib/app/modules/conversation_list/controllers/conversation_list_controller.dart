import 'package:get/get.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/services/message_service.dart';

class ConversationListController extends GetxController {
  var isLoading = true.obs;
  var conversationList = <Conversation>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  void fetchConversations() async {
    try {
      isLoading(true);
      var result = await MessageService.getConversations();
      conversationList.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat percakapan: $e");
    } finally {
      isLoading(false);
    }
  }
}
