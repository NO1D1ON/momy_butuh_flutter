import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_service.dart';
import 'dart:async'; // Import untuk Timer

class BabysitterSearchController extends GetxController {
  final searchC = TextEditingController();

  // 'debounce' untuk mencegah panggilan API pada setiap ketikan
  Timer? _debounce;

  var isLoading = false.obs;
  var searchResults = <Babysitter>[].obs;

  @override
  void onClose() {
    searchC.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  // Fungsi yang dipanggil setiap kali teks di kolom pencarian berubah
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 2) {
        performSearch(query);
      } else {
        searchResults.clear();
      }
    });
  }

  // Fungsi untuk melakukan pencarian ke API
  Future<void> performSearch(String query) async {
    try {
      isLoading(true);
      var results = await BabysitterService.searchBabysitters(query);
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar("Error", "Gagal melakukan pencarian: $e");
    } finally {
      isLoading(false);
    }
  }
}
