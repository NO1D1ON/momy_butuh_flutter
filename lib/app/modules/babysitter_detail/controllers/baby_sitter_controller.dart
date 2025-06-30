import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/models/babysitter_availibility_model.dart';
import '../../../data/services/babysitter_service.dart';

class BabysitterDetailController extends GetxController {
  var babysitter = Rxn<Babysitter>();
  var babysitterAvailability = Rxn<BabysitterAvailability>(); // Tambahkan ini
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic arguments = Get.arguments;

    if (arguments is BabysitterAvailability) {
      // Jika yang dikirim adalah object BabysitterAvailability dari beranda
      _loadFromAvailabilityObject(arguments);
    } else if (arguments is int) {
      // Fallback: jika yang dikirim adalah ID (untuk kompatibilitas)
      fetchDetail(arguments);
    } else {
      _handleInvalidArguments();
    }
  }

  // Method untuk memuat data dari object yang sudah ada
  void _loadFromAvailabilityObject(BabysitterAvailability availability) {
    try {
      isLoading(true);

      // Set data availability
      babysitterAvailability.value = availability;

      // Set data babysitter dari object availability
      babysitter.value = availability.babysitter;

      isLoading(false);
    } catch (e) {
      errorMessage.value = "Gagal memuat data babysitter";
      isLoading(false);
    }
  }

  // Method fallback untuk fetch via API (jika masih dibutuhkan)
  Future<void> fetchDetail(int id) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await BabysitterService.fetchBabysitterDetail(id);
      babysitter.value = result;
      // babysitterAvailability akan null dalam kasus ini
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      errorMessage.value = errorMsg;
      Get.snackbar(
        'Terjadi Kesalahan',
        errorMsg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void _handleInvalidArguments() {
    isLoading.value = false;
    errorMessage.value = "Gagal memuat: Data Babysitter tidak valid.";
    print(
      "Error: Argumen navigasi tidak valid. Diharapkan BabysitterAvailability atau int",
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) Get.back();
    });
  }

  // Getter untuk mendapatkan data yang konsisten
  Babysitter? get currentBabysitter => babysitter.value;
  BabysitterAvailability? get currentAvailability =>
      babysitterAvailability.value;

  // Method untuk mendapatkan info yang mungkin berbeda antara availability dan babysitter
  String get displayName =>
      babysitterAvailability.value?.name ??
      babysitter.value?.name ??
      'Nama tidak tersedia';
  String? get displayPhotoUrl =>
      babysitterAvailability.value?.photoUrl ?? babysitter.value?.photoUrl;
  int get displayAge =>
      babysitterAvailability.value?.age ?? babysitter.value?.age ?? 0;
  double get displayRating =>
      babysitterAvailability.value?.rating ?? babysitter.value?.rating ?? 0.0;
}
