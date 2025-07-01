import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/echo_service.dart'; // 1. Import EchoService
import 'package:momy_butuh_flutter/app/data/services/message_service.dart';
import 'package:momy_butuh_flutter/app/modules/map_view/map_view_controller.dart';
import 'package:momy_butuh_flutter/app/modules/profil/controllers/profile_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../conversation_list/controllers/conversation_list_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan service yang akan digunakan di banyak tempat sebagai service permanen.
    // fenix: true memastikan service ini tidak akan dihapus dari memori.
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    // 2. Daftarkan EchoService di sini sebagai service global.
    Get.lazyPut<EchoService>(() => EchoService(), fenix: true);

    // Daftarkan service lain yang dibutuhkan
    Get.lazyPut<MessageService>(
      () => MessageService(
        authService: Get.find<AuthService>(),
        httpClient: Client(),
      ),
    );

    // Daftarkan semua controller untuk setiap tab
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.lazyPut<BookingHistoryController>(() => BookingHistoryController());
    Get.lazyPut<MapViewController>(() => MapViewController());
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
