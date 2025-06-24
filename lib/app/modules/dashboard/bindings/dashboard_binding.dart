import 'package:get/get.dart';
// import 'package:momy_butuh_flutter/app/modules/booking/controllers/booking_controller.dart';
import 'package:momy_butuh_flutter/app/modules/booking_history/controllers/booking_history_controller.dart';
import 'package:momy_butuh_flutter/app/modules/conversation_list/controllers/conversation_list_controller.dart';
import 'package:momy_butuh_flutter/app/modules/favorite/controllers/favorite_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/dashboard_controller.dart';

// Binding ini akan mendaftarkan semua controller yang dibutuhkan oleh halaman utama.
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.lazyPut<ConversationListController>(() => ConversationListController());
    Get.lazyPut<BookingHistoryController>(() => BookingHistoryController());
  }
}
