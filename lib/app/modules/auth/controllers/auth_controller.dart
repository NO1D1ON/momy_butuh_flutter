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
  final passwordConfirmationController = TextEditingController();

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
    // Validasi di sisi klien
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmationController.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: "Data Kurang",
        desc: "Semua field wajib diisi.",
      ).show();
      return;
    }
    if (passwordConfirmationController.text !=
        passwordConfirmationController.text) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: "Gagal",
        desc: "Password dan Konfirmasi Password tidak cocok.",
      ).show();
      return;
    }

    isLoading.value = true;

    // Panggil service
    final result = await _authService.register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      passwordConfirmation: passwordConfirmationController.text,
    );

    isLoading.value = false;

    // Tampilkan notifikasi berdasarkan hasil
    AwesomeDialog(
      context: Get.context!,
      dialogType: result['success'] ? DialogType.success : DialogType.error,
      title: result['success'] ? 'Registrasi Berhasil' : 'Registrasi Gagal',
      desc: result['message'],
      btnOkOnPress: () {
        if (result['success']) {
          // Arahkan ke halaman login jika sukses
          Get.offNamed(Routes.LOGIN_PARENT);
        }
      },
      btnOkColor: result['success'] ? Colors.green : AppTheme.primaryColor,
    ).show();
  }
}
