import 'package:get/get.dart';
// Nanti kita akan buat model dan service-nya
// import '../../../data/models/job_offer_model.dart';
// import '../../../data/services/job_offer_service.dart';

class JobOfferDetailController extends GetxController {
  // Mengambil ID dari parameter navigasi
  final int jobOfferId = Get.arguments;

  var isLoading = true.obs;
  // var jobOffer = Rxn<JobOffer>(); // State untuk menyimpan data detail

  @override
  void onInit() {
    super.onInit();
    fetchJobOfferDetails();
  }

  void fetchJobOfferDetails() async {
    try {
      isLoading(true);
      // Nanti di sini kita akan panggil:
      // jobOffer.value = await JobOfferService.fetchOfferDetail(jobOfferId);

      // Untuk sekarang, kita gunakan data dummy
      await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat detail penawaran.");
    } finally {
      isLoading(false);
    }
  }

  void navigateToClientLocation() {
    // Logika untuk membuka Google Maps dengan pin di lokasi klien
    // double lat = jobOffer.value?.latitude ?? 0;
    // double lon = jobOffer.value?.longitude ?? 0;
    // MapsLauncher.launchCoordinates(lat, lon, 'Lokasi Klien');
    Get.snackbar("Fitur Peta", "Membuka peta di lokasi klien...");
  }
}
