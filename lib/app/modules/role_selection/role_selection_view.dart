import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo dan Judul
              Image.asset(
                'assets/images/logo.png', // <-- GANTI DENGAN PATH LOGO ANDA
                width: 100,
                height: 100, // Sesuaikan ukuran logo jika perlu
              ),
              const SizedBox(height: 10),
              const Text(
                'Selamat Datang di\nMomyButuh',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Masuk atau daftar sebagai:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Tombol untuk Orang Tua
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Ukuran rounded yang sama
                  ),
                ),
                onPressed: () {
                  Get.toNamed(Routes.LOGIN_PARENT);
                },
                child: const Text('Orang Tua', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Sama seperti ElevatedButton
                  ),
                ),
                onPressed: () {
                  Get.toNamed(Routes.LOGIN_BABYSITTER);
                },
                child: const Text(
                  'Babysitter',
                  style: TextStyle(fontSize: 16, color: AppTheme.primaryColor),
                ),
              ),

              // ...
            ],
          ),
        ),
      ),
    );
  }
}
