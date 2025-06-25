import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:momy_butuh_flutter/app/data/services/user_profile_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  // Gunakan Rxn agar bisa menampung nilai null di awal
  var userProfile = Rxn<UserProfile>();

  @override
  void onInit() {
    super.onInit();
    // Panggil data profil saat halaman pertama kali dibuka
    fetchProfile();
  }

  // Fungsi untuk mengambil data dari service
  void fetchProfile() async {
    try {
      isLoading(true);
      var result = await AuthService.getProfile();
      if (result['success']) {
        // Jika sukses, ubah JSON menjadi objek UserProfile dan simpan
        userProfile.value = UserProfile.fromJson(result['data']);
      } else {
        Get.snackbar("Error", result['message']);
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
        await AuthService.logout();
        // Arahkan ke halaman pilihan peran setelah logout
        Get.offAllNamed(Routes.ROLE_SELECTION);
      },
    ).show();
  }
}
