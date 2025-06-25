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
              const Icon(
                Icons.child_care,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 50),

              // Tombol untuk Orang Tua
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Arahkan ke halaman login Orang Tua yang sudah ada
                  Get.toNamed(Routes.LOGIN_PARENT);
                },
                child: const Text('Orang Tua', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),

              // Tombol untuk Babysitter
              // ...
              // Tombol untuk Babysitter
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppTheme.primaryColor),
                ),
                onPressed: () {
                  // PERBARUI INI: Arahkan ke halaman login Babysitter
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
