import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:momy_butuh_flutter/app/data/services/user_profile_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var userProfile = Rxn<UserProfile>();

  // Instance dari AuthService yang telah diperbarui
  final _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // Fungsi untuk mengambil data dari service
  void fetchProfile() async {
    try {
      isLoading(true);
      final result = await _authService.getProfile();
      if (result['success']) {
        userProfile.value = UserProfile.fromJson(result['data']);
      } else {
        Get.snackbar("Error", result['message'] ?? 'Gagal memuat profil');
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data profil: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fungsi logout
  void logout() {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.warning,
      title: 'Konfirmasi Logout',
      desc: 'Apakah Anda yakin ingin keluar dari akun ini?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await _authService.logout();
        Get.offAllNamed(Routes.ROLE_SELECTION);
      },
    ).show();
  }
}
