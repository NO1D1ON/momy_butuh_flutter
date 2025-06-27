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
      backgroundColor: Colors.white,
      body: Container(
        // // Gunakan Container untuk menambahkan dekorasi gradient
        // decoration: BoxDecoration(
        //   gradient: RadialGradient(
        //     // Tentukan pusat dan radius gradient
        //     center: Alignment.center,
        //     radius: 0.8, // Radius 0.8 membuat area pink dominan di tengah
        //     // Tentukan warna gradient dari pink ke putih
        //     colors: [
        //       AppTheme.primaryColor, // Warna pink di tengah
        //       Colors.white,         // Warna putih di pinggir
        //     ],
        //   ),
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ganti Icon dengan Image.asset dari path logo Anda
              // PASTIKAN path 'assets/images/logo.png' sudah benar dan
              // sudah didaftarkan di file pubspec.yaml
              Image.asset(
                'assets/images/logo.png', // <-- GANTI DENGAN PATH LOGO ANDA
                width: 150, // Sesuaikan ukuran logo jika perlu
              ),
              const SizedBox(height: 20),
              const Text(
                'MomyButuh',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Teks tetap putih agar kontras
                  shadows: [
                    // Tambahkan bayangan agar teks lebih terbaca
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
