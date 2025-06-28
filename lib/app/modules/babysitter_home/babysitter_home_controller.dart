import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/joboffer_model.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart'; // 1. Impor AuthService
import 'package:momy_butuh_flutter/app/data/services/joboffer_service.dart';

class BabysitterHomeController extends GetxController {
  // 2. Buat instance dari AuthService untuk mengambil profil
  final AuthService _authService = AuthService();

  // State untuk nama, loading, dan daftar pekerjaan
  var babysitterName = "Babysitter".obs;
  var isLoading = true.obs;
  var jobOfferList = <JobOffer>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 3. Panggil kedua fungsi saat controller diinisialisasi
    fetchBabysitterProfile();
    fetchData();
  }

  // 4. Fungsi baru untuk mengambil data profil babysitter langsung dari API
  Future<void> fetchBabysitterProfile() async {
    try {
      // Panggil method getProfile dari AuthService
      final result = await _authService.getProfile();
      if (result['success'] && result['data'] != null) {
        // Perbarui state babysitterName dengan nama dari API
        babysitterName.value = result['data']['name'];
      }
    } catch (e) {
      // Jika terjadi error, cetak ke konsol untuk debugging
      print("Gagal memuat profil babysitter: $e");
      // Biarkan nama default "Babysitter" jika gagal
    }
  }

  // Fungsi untuk mengambil data tawaran pekerjaan
  Future<void> fetchData() async {
    try {
      isLoading(true);
      var offers = await JobOfferService.fetchJobOffers();
      jobOfferList.assignAll(offers);
    } catch (e) {
      Get.snackbar(
        'Gagal Memuat',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
