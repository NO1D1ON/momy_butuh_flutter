import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/modules/splash/controllers/splash.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan AuthService agar bisa ditemukan oleh Get.find()
    Get.lazyPut<AuthService>(() => AuthService());

    // Daftarkan SplashController
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
