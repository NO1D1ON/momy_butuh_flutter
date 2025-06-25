import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_auth_service.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBabysitterController extends GetxController {
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Controllers untuk Register
  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerPasswordConfirmController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerBirthDateController = TextEditingController();
  final registerAddressController = TextEditingController();
  var isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    var result = await BabysitterAuthService.login(
      loginEmailController.text,
      loginPasswordController.text,
    );
    isLoading.value = false;

    if (result.containsKey('access_token')) {
      final prefs = await SharedPreferences.getInstance();
      // Simpan token dengan kunci yang berbeda untuk membedakan peran
      await prefs.setString('auth_token_babysitter', result['access_token']);
      await prefs.setString('user_role', 'babysitter'); // Simpan peran

      Get.offAllNamed(
        Routes.DASHBOARD_BABYSITTER,
      ); // Arahkan ke dashboard yang sama
    } else {
      Get.snackbar(
        'Login Gagal',
        result['message'] ?? 'Email atau password salah',
      );
    }
  }

  // Method baru untuk registrasi
  Future<void> register() async {
    isLoading.value = true;
    var result = await BabysitterAuthService.register(
      name: registerNameController.text,
      email: registerEmailController.text,
      password: registerPasswordController.text,
      passwordConfirmation: registerPasswordConfirmController.text,
      phoneNumber: registerPhoneController.text,
      birthDate: registerBirthDateController.text,
      address: registerAddressController.text,
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
          // Kembali ke halaman login babysitter jika sukses
          Get.back();
        }
      },
      btnOkColor: result['success'] ? Colors.green : AppTheme.primaryColor,
    ).show();
  }
}
