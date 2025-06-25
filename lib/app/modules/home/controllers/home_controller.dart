import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/babysitter_service.dart';
// Asumsikan Anda punya service untuk mengambil profil user
// import '../../../data/services/auth_service.dart';
// import '../../../data/models/user_profile_model.dart';

class HomeController extends GetxController {
  // State untuk menyimpan nama pengguna
  var parentName = "Orang Tua".obs; // Nilai default

  // State untuk loading dan daftar babysitter
  var isLoading = true.obs;
  var babysitterList = <Babysitter>[].obs;

  get favoriteIds => null;

  @override
  void onInit() {
    super.onInit();
    // Panggil kedua fungsi untuk mengambil data saat halaman dibuka
    fetchParentProfile();
    fetchBabysitters();
  }

  // Fungsi untuk mengambil data profil orang tua
  void fetchParentProfile() async {
    try {
      var result = await AuthService.getProfile();
      if (result['success']) {
        parentName.value = result['data']['name'];
      }
    } catch (e) {
      print("Gagal memuat nama parent: $e");
    }
  }

  // Fungsi untuk mengambil data babysitter dari service
  void fetchBabysitters() async {
    try {
      isLoading(true);
      var babysitters = await BabysitterService.fetchBabysitters();
      babysitterList.assignAll(babysitters);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data babysitter: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void toggleFavorite(int id) {}
}
