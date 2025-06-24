import 'package:get/get.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/babysitter_service.dart';

class BabysitterDetailController extends GetxController {
  // Gunakan 'Rxn' untuk tipe data yang bisa null
  var babysitter = Rxn<Babysitter>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil ID yang dikirim dari halaman sebelumnya
    final int babysitterId = Get.arguments;
    fetchDetail(babysitterId);
  }

  void fetchDetail(int id) async {
    try {
      isLoading(true);
      var result = await BabysitterService.fetchBabysitterDetail(id);
      babysitter.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data: $e');
    } finally {
      isLoading(false);
    }
  }
}
