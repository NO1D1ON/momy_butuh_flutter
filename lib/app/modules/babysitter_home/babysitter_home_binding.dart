import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_home/babysitter_home_controller.dart';

class BabysitterHomeBinding extends Bindings {
  @override
  void dependencies() {
    // Menggunakan Get.put() untuk memastikan controller langsung tersedia
    Get.put<BabysitterHomeController>(BabysitterHomeController());

    // Alternatif dengan lazyPut jika ingin lazy loading
    // Get.lazyPut<BabysitterHomeController>(() => BabysitterHomeController());
  }
}
