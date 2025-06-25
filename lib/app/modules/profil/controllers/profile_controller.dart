import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ProfileController extends GetxController {
  void logout() {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.warning,
      title: 'Konfirmasi Logout',
      desc: 'Apakah Anda yakin ingin keluar dari akun ini?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await AuthService.logout();
        Get.offAllNamed(
          Routes.ROLE_SELECTION,
        ); // Arahkan ke login setelah logout
      },
    ).show();
  }
}
