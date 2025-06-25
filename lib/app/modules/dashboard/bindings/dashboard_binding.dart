import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/profil/controllers/profile_controller.dart';

// Import semua controller yang akan digunakan di dalam dashboard
import '../../home/controllers/home_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../conversation_list/controllers/conversation_list_controller.dart';
import '../controllers/dashboard_controller.dart';

// Binding ini akan mendaftarkan SEMUA controller yang dibutuhkan oleh
// halaman-halaman utama yang diakses melalui BottomNavigationBar.
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.lazyPut<BookingHistoryController>(() => BookingHistoryController());
    Get.lazyPut<ConversationListController>(() => ConversationListController());

    // DAFTARKAN PROFILE CONTROLLER DI SINI
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
