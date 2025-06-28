import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Impor enum UserType yang telah kita buat
import '../../../data/models/user_type.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/theme.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final _authService = AuthService();

  // Fungsi login khusus untuk Orang Tua
  Future<void> loginAsParent() async {
    isLoading.value = true;

    // Panggil service login dengan peran yang sudah ditentukan
    final result = await _authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
      UserType.parent, // Eksplisit tentukan peran sebagai Orang Tua
    );

    isLoading.value = false;

    if (result['success']) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Login Berhasil',
        desc: result['data']['message'] ?? 'Selamat datang!',
        btnOkOnPress: () {
          // Arahkan ke dashboard Orang Tua
          Get.offAllNamed(Routes.DASHBOARD_PARENT);
        },
      ).show();
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Login Gagal',
        desc: result['message'] ?? 'Email atau password salah.',
        btnOkOnPress: () {},
        btnOkColor: AppTheme.primaryColor,
      ).show();
    }
  }

  // Fungsi registrasi untuk Orang Tua
  Future<void> register() async {
    isLoading.value = true;

    final result = await _authService.register(
      // Asumsi ada method register di AuthService
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading.value = false;

    // Tampilkan dialog berdasarkan hasil registrasi...
    if (result['success']) {
      // Dialog sukses
    } else {
      // Dialog error
    }
  }
}
