import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_service.dart';

class BabysitterSearchController extends GetxController {
  final searchController = TextEditingController();

  // 'debounce' untuk mencegah panggilan API pada setiap ketikan
  final RxString _searchQuery = ''.obs;

  var isLoading = false.obs;
  var searchResults = <Babysitter>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Dengarkan perubahan pada _searchQuery dan tunggu 500ms sebelum mencari
    debounce(
      _searchQuery,
      (_) => performSearch(),
      time: const Duration(milliseconds: 500),
    );
  }

  // Fungsi yang dipanggil setiap kali teks di kolom pencarian berubah
  void onSearchChanged(String query) {
    _searchQuery.value = query;
  }

  // Fungsi untuk melakukan pencarian ke API
  Future<void> performSearch() async {
    // Hanya cari jika kata kunci lebih dari 1 huruf
    if (_searchQuery.value.length < 2) {
      searchResults.clear();
      return;
    }

    try {
      isLoading(true);
      var results = await BabysitterService.searchBabysitters(
        _searchQuery.value,
      );
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar("Error", "Gagal melakukan pencarian: $e");
    } finally {
      isLoading(false);
    }
  }
}
