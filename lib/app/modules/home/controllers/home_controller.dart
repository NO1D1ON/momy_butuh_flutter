import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_service.dart';
import 'package:momy_butuh_flutter/app/data/services/favorite_service.dart';

class HomeController extends GetxController {
  // State untuk loading dan daftar babysitter
  var isLoading = true.obs;
  var babysitterList = <Babysitter>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil fungsi untuk mengambil data saat controller diinisialisasi
    fetchData();
  }

  // Fungsi untuk mengambil data dari service
  void fetchData() async {
    try {
      isLoading(true);
      var babysitters = await BabysitterService.fetchBabysitters();
      babysitterList.assignAll(babysitters);
    } catch (e) {
      // Tampilkan error jika gagal
      Get.snackbar('Error', 'Gagal memuat data: $e');
    } finally {
      isLoading(false);
    }
  }

  void toggleFavorite(int babysitterId) async {
    var result = await FavoriteService.toggleFavorite(babysitterId);
    // Tampilkan notifikasi pop-up dari hasil API
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Info',
      desc: result['message'],
      btnOkOnPress: () {},
    ).show();
  }
}
