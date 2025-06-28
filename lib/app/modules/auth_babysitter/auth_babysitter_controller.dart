import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Impor yang diperlukan
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart'; // Gunakan service utama
import 'package:momy_butuh_flutter/app/data/models/user_type.dart'; // Gunakan enum UserType
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class AuthBabysitterController extends GetxController {
  // Controller untuk login
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Controller untuk register (bisa disesuaikan nanti)
  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerPasswordConfirmController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerBirthDateController = TextEditingController();
  final registerAddressController = TextEditingController();
  // ... controller register lainnya

  final isLoading = false.obs;
  // Gunakan instance dari AuthService utama
  final _authService = AuthService();

  // Fungsi login khusus untuk Babysitter
  Future<void> loginAsBabysitter() async {
    isLoading.value = true;

    // Panggil service login dengan peran yang sudah ditentukan
    final result = await _authService.login(
      loginEmailController.text.trim(),
      loginPasswordController.text.trim(),
      UserType.babysitter, // Eksplisit tentukan peran sebagai Babysitter
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
          // Arahkan ke dashboard Babysitter
          Get.offAllNamed(Routes.DASHBOARD_BABYSITTER);
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

  // Fungsi registrasi untuk Babysitter
  Future<void> register() async {
    // Validasi sederhana, misalnya password harus sama
    if (registerPasswordController.text !=
        registerPasswordConfirmController.text) {
      Get.snackbar('Error', 'Konfirmasi password tidak cocok.');
      return;
    }

    isLoading.value = true;

    // Panggil metode baru dari AuthService
    final result = await _authService.registerAsBabysitter(
      name: registerNameController.text.trim(),
      email: registerEmailController.text.trim(),
      password: registerPasswordController.text,
      passwordConfirmation: registerPasswordConfirmController.text,
      phoneNumber: registerPhoneController.text.trim(),
      birthDate: registerBirthDateController.text,
      address: registerAddressController.text.trim(),
    );

    isLoading.value = false;

    AwesomeDialog(
      context: Get.context!,
      dialogType: result['success'] ? DialogType.success : DialogType.error,
      animType: AnimType.scale,
      title: result['success'] ? 'Registrasi Berhasil' : 'Registrasi Gagal',
      desc: result['message'],
      btnOkOnPress: () {
        if (result['success']) {
          // Jika berhasil, bersihkan field dan kembali ke halaman login
          _clearRegisterFields();
          Get.back();
        }
      },
      btnOkColor: result['success'] ? Colors.green : AppTheme.primaryColor,
    ).show();
  }

  void _clearRegisterFields() {
    registerNameController.clear();
    registerEmailController.clear();
    registerPasswordController.clear();
    registerPasswordConfirmController.clear();
    registerPhoneController.clear();
    registerBirthDateController.clear();
    registerAddressController.clear();
  }
}
