import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/joboffer_model.dart';
import 'package:momy_butuh_flutter/app/data/services/joboffer_service.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_home/babysitter_home_controller.dart';

class JobOfferDetailController extends GetxController {
  // Mengambil ID yang dikirim dari halaman sebelumnya
  final int jobOfferId = Get.arguments;

  // State untuk loading dan data penawaran
  var isLoading = true.obs;
  var isAccepting = false.obs;
  var jobOffer = Rx<JobOffer?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchJobOfferDetails();
  }

  /// Mengambil detail dari service menggunakan ID
  Future<void> fetchJobOfferDetails() async {
    try {
      isLoading(true);
      final offer = await JobOfferService.fetchJobOfferById(jobOfferId);
      jobOffer.value = offer;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail penawaran: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  /// Menerima tawaran pekerjaan
  Future<void> acceptOffer() async {
    try {
      isAccepting(true);
      final result = await JobOfferService.acceptJobOffer(jobOfferId);

      if (result['success']) {
        Get.back(); // Kembali ke halaman beranda
        Get.snackbar(
          'Berhasil',
          result['message'] ?? 'Anda telah menerima tawaran ini.',
        );

        // Refresh daftar pekerjaan di halaman beranda
        final homeController = Get.find<BabysitterHomeController>();
        homeController.fetchData();
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Tidak dapat menerima penawaran saat ini.',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isAccepting(false);
    }
  }
}
