import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_dashboard/babysitter_dashboard_controller.dart';

// Kelas ini bertugas mendaftarkan BabysitterDashboardController
class BabysitterDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Menggunakan lazyPut agar controller hanya dibuat saat pertama kali dibutuhkan
    Get.lazyPut<BabysitterDashboardController>(
      () => BabysitterDashboardController(),
    );
  }
}
