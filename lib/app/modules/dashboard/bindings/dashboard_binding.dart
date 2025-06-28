import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/message_service.dart';
import 'package:momy_butuh_flutter/app/modules/map_view/map_view_controller.dart';
import 'package:momy_butuh_flutter/app/modules/profil/controllers/profile_controller.dart';

// Import semua controller yang akan digunakan di dalam dashboard
import '../../home/controllers/home_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../conversation_list/controllers/conversation_list_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.lazyPut<BookingHistoryController>(() => BookingHistoryController());
    Get.lazyPut<MapViewController>(() => MapViewController());

    // Tambahkan AuthService dan MessageService sebagai dependensi
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
  }
}
