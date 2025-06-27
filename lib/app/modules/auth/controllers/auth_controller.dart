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

  // PERBAIKAN 1: Tambahkan state untuk menyimpan tipe pengguna yang dipilih.
  // Kita buat sebagai Rx (reaktif) agar UI bisa otomatis update jika perlu.
  final selectedUserType = UserType.parent.obs;

  // PERBAIKAN 2: Buat metode untuk mengubah tipe pengguna dari UI.
  void changeUserType(UserType userType) {
    selectedUserType.value = userType;
  }

  // Fungsi login yang sudah diperbaiki
  Future<void> login() async {
    isLoading.value = true;

    // PERBAIKAN 3: Gunakan state 'selectedUserType.value' saat memanggil login.
    final result = await _authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
      selectedUserType.value, // Kirim tipe pengguna yang dipilih
    );

    isLoading.value = false;

    if (result['success']) {
      // PERBAIKAN 4: Arahkan ke dashboard yang benar berdasarkan tipe pengguna.
      final destination = selectedUserType.value == UserType.parent
          ? Routes.DASHBOARD_PARENT
          : Routes.DASHBOARD_BABYSITTER; // Pastikan Anda punya rute ini

      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Login Berhasil',
        desc: result['data']['message'] ?? 'Selamat datang!',
        btnOkOnPress: () {
          Get.offAllNamed(destination);
        },
      ).show();
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Login Gagal',
        desc: result['message'] ?? 'Terjadi kesalahan saat login.',
        btnOkOnPress: () {},
        btnOkColor: AppTheme.primaryColor,
      ).show();
    }
  }

  // Fungsi registrasi (tidak perlu diubah jika hanya untuk Orang Tua)
  Future<void> register() async {
    isLoading.value = true;
    // ... (logika registrasi Anda tetap sama)
    // ...
    isLoading.value = false;
  }
}
