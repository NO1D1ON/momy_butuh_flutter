import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/message_service.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_booking/babysitter_booking_controller.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_dashboard/babysitter_dashboard_controller.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_home/babysitter_home_controller.dart';
import 'package:momy_butuh_flutter/app/modules/conversation_list/controllers/conversation_list_controller.dart';
import 'package:momy_butuh_flutter/app/modules/profil/controllers/profile_controller.dart';

// Import semua controller yang akan digunakan di dalam dashboard babysitter

class BabysitterDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan controller utama untuk dashboard
    Get.lazyPut<BabysitterDashboardController>(
      () => BabysitterDashboardController(),
    );

    // Daftarkan semua controller untuk setiap tab
    Get.lazyPut<BabysitterHomeController>(() => BabysitterHomeController());
    // Get.lazyPut<BabysitterBookingsController>(() => BabysitterBookingsController());
    Get.lazyPut<AuthService>(() => AuthService());

    Get.lazyPut<MessageService>(
      () => MessageService(
        authService: Get.find<AuthService>(),
        httpClient: Client(),
      ),
    );

    Get.lazyPut<ConversationListController>(
      () => ConversationListController(
        messageService: Get.find<MessageService>(),
        authService: Get.find<AuthService>(),
        httpClient: Client(),
      ),
    );
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<BabysitterBookingsController>(
      () => BabysitterBookingsController(),
    );
  }
}
