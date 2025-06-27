import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/babysitter_service.dart';

class HomeController extends GetxController {
  // State untuk menyimpan nama pengguna
  var parentName = "Orang Tua".obs;

  // State untuk loading dan daftar babysitter
  var isLoading = true.obs;
  var babysitterList = <Babysitter>[].obs;

  // Instance dari AuthService yang sudah diperbarui
  final _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    fetchParentProfile();
    fetchBabysitters();
  }

  // Fungsi untuk mengambil data profil orang tua
  void fetchParentProfile() async {
    try {
      final result = await _authService.getProfile();
      if (result['success']) {
        parentName.value = result['data']['name'];
      } else {
        print("Gagal memuat profil: ${result['message']}");
      }
    } catch (e) {
      print("Gagal memuat nama parent: $e");
    }
  }

  // Fungsi untuk mengambil data babysitter dari service
  void fetchBabysitters() async {
    try {
      isLoading(true);
      final babysitters = await BabysitterService.fetchBabysitters();
      babysitterList.assignAll(babysitters);
    } catch (e) {
      print('Gagal memuat data babysitter: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }
}
