import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/topup/topup_controller.dart';

// Binding untuk mendaftarkan TopupController
class TopupBinding extends Bindings {
  @override
  void dependencies() {
    // Gunakan lazyPut agar controller hanya dibuat saat pertama kali dibutuhkan
    Get.lazyPut<TopupController>(() => TopupController());
  }
}
