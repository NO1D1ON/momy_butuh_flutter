import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/map_view/map_view_controller.dart';

// Kelas ini bertugas untuk mendaftarkan MapViewController
class MapBinding extends Bindings {
  @override
  void dependencies() {
    // Menggunakan lazyPut agar controller hanya dibuat saat pertama kali dibutuhkan
    Get.lazyPut<MapViewController>(() => MapViewController());
  }
}
