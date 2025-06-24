import 'package:get/get.dart';
import '../controllers/booking_history_controller.dart';

// Binding ini bertugas untuk mendaftarkan BookingHistoryController
// saat rute untuk riwayat booking diakses.
class BookingHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingHistoryController>(() => BookingHistoryController());
  }
}
