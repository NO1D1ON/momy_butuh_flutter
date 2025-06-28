import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/babysitter_service.dart';

class BabysitterDetailController extends GetxController {
  var babysitter = Rxn<Babysitter>();
  var isLoading = true.obs;
  var errorMessage = ''.obs; // State untuk pesan error yang lebih jelas

  @override
  void onInit() {
    super.onInit();
    // Argumen yang dikirim dari halaman home adalah ID
    final dynamic babysitterId = Get.arguments;

    if (babysitterId is int) {
      fetchDetail(babysitterId);
    } else {
      isLoading.value = false;
      errorMessage.value = "Gagal memuat: ID Babysitter tidak valid.";
      print(
        "Error: Argumen navigasi tidak valid. Diharapkan int, diterima ${babysitterId.runtimeType}",
      );
      // Otomatis kembali jika ID tidak ada
      Future.delayed(const Duration(seconds: 2), () {
        if (!isClosed) Get.back();
      });
    }
  }

  Future<void> fetchDetail(int id) async {
    try {
      isLoading(true);
      errorMessage(''); // Reset error setiap kali fetch
      final result = await BabysitterService.fetchBabysitterDetail(id);
      babysitter.value = result;
    } catch (e) {
      // Tangkap pesan error dari service dan tampilkan
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      errorMessage.value = errorMsg;
      Get.snackbar(
        'Terjadi Kesalahan',
        errorMsg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
      );
      // print('Error fetchDetail: $e');
    } finally {
      isLoading(false);
    }
  }
}
