// File: lib/app/modules/auth_babysitter/auth_babysitter_controller.dart

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 1. Impor flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Impor yang diperlukan
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/models/user_type.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class AuthBabysitterController extends GetxController {
  // Controller untuk login
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Controller untuk register
  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerPasswordConfirmController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerBirthDateController = TextEditingController();
  final registerAddressController = TextEditingController();

  final isLoading = false.obs;
  final _authService = AuthService();
  // 2. Buat instance storage
  final _storage = const FlutterSecureStorage();

  // Fungsi login khusus untuk Babysitter
  Future<void> loginAsBabysitter() async {
    isLoading.value = true;

    final result = await _authService.login(
      loginEmailController.text.trim(),
      loginPasswordController.text.trim(),
      UserType.babysitter,
    );

    isLoading.value = false;

    if (result['success']) {
      // 3. SIMPAN NAMA BABYSITTER SETELAH LOGIN BERHASIL
      // Pastikan backend mengembalikan nama dalam object 'user' di dalam 'data'
      final userName = result['data']['user']['name'];
      if (userName != null) {
        await _storage.write(key: 'babysitter_name', value: userName);
      }
      // --- Batas Penambahan ---

      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Login Berhasil',
        desc: result['data']['message'] ?? 'Selamat datang!',
        btnOkOnPress: () {
          // Arahkan ke dashboard Babysitter (menggunakan route yang benar)
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
    if (registerPasswordController.text !=
        registerPasswordConfirmController.text) {
      Get.snackbar('Error', 'Konfirmasi password tidak cocok.');
      return;
    }

    isLoading.value = true;

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
