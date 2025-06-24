import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/splash/controllers/splash.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

// Tampilan untuk splash screen.
class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Panggil controller agar logikanya berjalan
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Gunakan warna pink
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan path logo Anda di folder assets
            // Image.asset('assets/logo_white.png', width: 150),
            const Icon(Icons.child_care, color: Colors.white, size: 100),
            const SizedBox(height: 20),
            const Text(
              'MomyButuh',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Catatan: Jangan lupa import AppTheme dari file theme.dart
// import 'package:momybutuh_flutter/app/utils/theme.dart';