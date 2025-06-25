import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/joboffer_model.dart';
import 'package:momy_butuh_flutter/app/data/services/joboffer_service.dart';

class BabysitterHomeController extends GetxController {
  // State untuk menyimpan nama babysitter
  var babysitterName = "Jessica".obs; // Ini bisa diambil dari data login nanti

  // State untuk loading dan daftar penawaran pekerjaan
  var isLoading = true.obs;
  var jobOfferList = <JobOffer>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil fungsi untuk mengambil data saat halaman pertama kali dibuka
    fetchData();
  }

  void fetchData() async {
    try {
      isLoading(true);
      var offers = await JobOfferService.fetchJobOffers();
      jobOfferList.assignAll(offers);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data penawaran: $e');
    } finally {
      isLoading(false);
    }
  }
}
