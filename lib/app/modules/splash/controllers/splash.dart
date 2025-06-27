import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:momy_butuh_flutter/app/routes/app_pages.dart';

// Controller untuk halaman splash screen, hanya berisi logika.
class SplashController extends GetxController {
  // onReady adalah bagian dari lifecycle GetxController yang akan
  // dieksekusi setelah widget selesai di-render.
  // Ini adalah tempat yang tepat untuk menjalankan pengecekan otentikasi.
  @override
  void onReady() {
    super.onReady();
    _checkAuth();
  }

  // Fungsi untuk mengecek status otentikasi pengguna.
  // Logikanya sama persis dengan Kode 2 asli Anda.
  void _checkAuth() async {
    // Memberi jeda 2 detik untuk menampilkan splash screen.
    await Future.delayed(const Duration(seconds: 2));

    // Mengambil instance dari SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    // Mengecek apakah ada 'auth_token' yang tersimpan.
    final String? token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      // Jika token ada, cek peran (role) pengguna.
      final String? role = prefs.getString('user_role');
      if (role == 'babysitter') {
        // Arahkan ke dashboard babysitter dan hapus semua riwayat navigasi sebelumnya.
        Get.offAllNamed(Routes.DASHBOARD_BABYSITTER);
      } else {
        // Arahkan ke dashboard orang tua dan hapus semua riwayat navigasi sebelumnya.
        Get.offAllNamed(Routes.DASHBOARD_PARENT);
      }
    } else {
      // Jika tidak ada token, arahkan pengguna ke halaman pemilihan peran.
      Get.offAllNamed(Routes.ROLE_SELECTION);
    }
  }
}
