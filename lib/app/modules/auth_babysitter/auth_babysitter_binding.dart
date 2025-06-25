import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/auth_babysitter/auth_babysitter_controller.dart';

// Kelas ini bertugas mendaftarkan AuthBabysitterController
class AuthBabysitterBinding extends Bindings {
  @override
  void dependencies() {
    // Menggunakan lazyPut agar controller hanya dibuat saat pertama kali dibutuhkan
    Get.lazyPut<AuthBabysitterController>(() => AuthBabysitterController());
  }
}
