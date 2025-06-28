import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/auth_babysitter/auth_babysitter_controller.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class LoginBabysitterView extends GetView<AuthBabysitterController> {
  const LoginBabysitterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Babysitter")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/logo.png', // <-- GANTI DENGAN PATH LOGO ANDA
              width: 100,
              height: 100, // Sesuaikan ukuran logo jika perlu
            ),
            const Text(
              "Login Babysitter",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controller.loginEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.loginPasswordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.loginAsBabysitter(),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Login"),
              ),
            ),
            // --- TAMBAHKAN KODE INI ---
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun?"),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.REGISTER_BABYSITTER),
                  child: const Text(
                    'Daftar di sini',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
            // --- BATAS PENAMBAHAN ---
          ],
        ),
      ),
    );
  }
}
