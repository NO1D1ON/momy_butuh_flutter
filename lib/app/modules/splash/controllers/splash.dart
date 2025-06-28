import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart'; // Impor service
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
// Impor enum UserType jika Anda membuatnya
// import 'package:momy_butuh_flutter/app/data/models/user_type.dart';

class SplashController extends GetxController {
  // PERBAIKAN: Gunakan Get.find() untuk mendapatkan instance AuthService
  // Ini adalah praktik yang baik dengan GetX, dengan asumsi service sudah di-inject.
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    // Beri jeda agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 2));

    // PERBAIKAN: Panggil metode dari AuthService, bukan _storage langsung.
    final String? token = await _authService.getToken();
    final String? userTypeString = await _authService.getUserType();

    if (token != null && token.isNotEmpty) {
      // Logika pengalihan Anda sudah benar, tidak ada perubahan di sini.
      if (userTypeString == 'UserType.babysitter') {
        Get.offAllNamed(Routes.DASHBOARD_BABYSITTER); // Pastikan rute ini ada
      } else {
        Get.offAllNamed(Routes.DASHBOARD_PARENT); // Pastikan rute ini ada
      }
    } else {
      // Arahkan ke halaman pemilihan peran atau login jika tidak ada token.
      Get.offAllNamed(Routes.ROLE_SELECTION); // Pastikan rute ini ada
    }
  }
}
