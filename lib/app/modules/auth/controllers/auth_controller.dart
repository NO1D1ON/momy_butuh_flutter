import 'package:awesome_dialog/awesome_dialog.dart'; // Ganti elegant_notification
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/theme.dart'; // Tambahkan jika menggunakan warna khusus

// Controller untuk logika login dan registrasi
class AuthController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  // Fungsi login
  Future<void> login() async {
    isLoading.value = true;

    var result = await AuthService.login(
      emailController.text,
      passwordController.text,
    );

    isLoading.value = false;

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result['data']['access_token']);

      // Notifikasi sukses dengan AwesomeDialog
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Login Berhasil',
        desc: result['data']['message'],
        btnOkOnPress: () {},
      ).show();

      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(Routes.HOME);
    } else {
      // Notifikasi gagal dengan AwesomeDialog
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Login Gagal',
        desc: result['message'],
        btnOkOnPress: () {},
        btnOkColor: AppTheme.primaryColor, // Gunakan tema jika diinginkan
      ).show();
    }
  }

  // Fungsi registrasi
  Future<void> register() async {
    isLoading.value = true;
    var result = await AuthService.register(
      nameController.text,
      emailController.text,
      passwordController.text,
    );
    isLoading.value = false;

    if (result['success']) {
      // Membersihkan input field setelah berhasil
      nameController.clear();
      emailController.clear();
      passwordController.clear();

      // Tampilkan notifikasi pop-up sukses dengan aksi
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Registrasi Berhasil',
        desc: result['message'],
        // AKSI SETELAH TOMBOL OK DITEKAN
        btnOkOnPress: () {
          // Kembali ke halaman login
          Get.back();
        },
      ).show();
    } else {
      // Tampilkan notifikasi pop-up error
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Registrasi Gagal',
        // Tampilkan pesan error dari server
        desc: result['message'],
        btnOkOnPress: () {},
        btnOkColor: AppTheme.primaryColor,
      ).show();
    }
  }
}
