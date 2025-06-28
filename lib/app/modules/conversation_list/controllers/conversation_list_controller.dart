import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import 'package:momy_butuh_flutter/app/data/models/conversation_model.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/message_service.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';

class ConversationListController extends GetxController {
  // Dependensi yang akan di-inject oleh binding
  final MessageService messageService;
  final AuthService authService;
  final http.Client httpClient;

  ConversationListController({
    required this.messageService,
    required this.authService,
    required this.httpClient,
  });

  // State untuk UI
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
      var result = await messageService.getConversations();
      conversationList.assignAll(result);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat percakapan",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  // Metode untuk menavigasi ke halaman chat
  void navigateToChat(Conversation conversation) {
    final babysitterArgument = Babysitter(
      id: conversation.otherPartyId,
      name: conversation.otherPartyName,
      // Beri nilai default untuk field lain yang mungkin required
      photoUrl: null,
      bio: '',
      ratePerHour: 0,
      rating: 0,
      age: 0,
      address: '',
    );

    // Gunakan Get.toNamed dan kirim argumen yang benar
    Get.toNamed(
      Routes.CHAT, // Gunakan rute bernama
      arguments: babysitterArgument, // Kirim objek Babysitter
    );
  }

  // Metode untuk menavigasi ke halaman memulai chat baru
  // void navigateToNewChat() {
  //   Get.toNamed(Routes.BABYSITTER_LIST); // Asumsi Anda punya rute ini
  // }
}
