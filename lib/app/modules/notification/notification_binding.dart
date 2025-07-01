import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/echo_service.dart';
import 'package:momy_butuh_flutter/app/modules/notification/notfication_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    // PERBAIKAN: Pastikan service yang dibutuhkan oleh controller sudah terdaftar.
    // Menggunakan fenix: true agar service tidak dihapus saat halaman ditutup,
    // karena mungkin masih digunakan di tempat lain.
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<EchoService>(() => EchoService(), fenix: true);

    // Daftarkan controller utama halaman ini.
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
