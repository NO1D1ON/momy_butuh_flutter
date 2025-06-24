import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:momy_butuh_flutter/app/routes/app_pages.dart';

// Controller untuk halaman splash screen.
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Fungsi ini akan dijalankan setelah UI siap.
    _checkAuth();
  }

  // Fungsi untuk mengecek status otentikasi (apakah ada token tersimpan)
  void _checkAuth() async {
    // Beri jeda 2 detik untuk menampilkan logo
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      // Jika ada token, arahkan ke halaman utama (home)
      Get.offAllNamed(Routes.HOME);
    } else {
      // Jika tidak ada token, arahkan ke halaman login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
