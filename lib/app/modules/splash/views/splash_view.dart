import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/splash/controllers/splash.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Panggil controller agar proses logika berjalan (jika belum diinisialisasi di binding)
    Get.find<SplashController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Aplikasi
            Image.asset(
              'assets/images/logo.png', // pastikan sudah didaftarkan di pubspec.yaml
              width: 225,
            ),
            const SizedBox(height: 10),
            // const CircularProgressIndicator(color: AppTheme.primaryColor),
            // const SizedBox(height: 24),
            const Text(
              'Momy Butuh',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF37199),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
