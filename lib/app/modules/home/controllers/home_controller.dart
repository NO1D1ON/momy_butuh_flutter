import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Import untuk notifikasi
import 'package:momy_butuh_flutter/app/data/models/babysitter_availibility_model.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_available_service.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/babysitter_service.dart';
import '../../../data/services/favorite_service.dart'; // <-- 1. Import service baru untuk favorit
import '../../../data/services/auth_service.dart'; // Anda sudah punya ini

class HomeController extends GetxController {
  // State untuk menyimpan nama pengguna
  var parentName = "Orang Tua".obs;

  // State untuk loading dan daftar babysitter
  var isLoading = true.obs;
  var availabilityList = <BabysitterAvailability>[].obs;

  // --- 2. STATE BARU UNTUK MENYIMPAN DAFTAR ID FAVORIT ---
  // Kita gunakan Set agar tidak ada ID duplikat dan pengecekan lebih cepat
  var favoriteIds = <int>{}.obs;

  // Instance dari AuthService
  final _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // Panggil semua data yang dibutuhkan saat halaman dibuka
    fetchInitialData();
    fetchAvailabilities();
    fetchFavoriteIds();
  }

  // --- 3. FUNGSI BARU UNTUK MEMUAT SEMUA DATA AWAL ---
  void fetchInitialData() async {
    isLoading(true);
    await fetchParentProfile();
    fetchAvailabilities();
    await fetchFavoriteIds(); // Panggil data favorit setelah daftar babysitter ada
    isLoading(false);
  }

  // Fungsi fetchParentProfile Anda sudah benar
  // Fungsi untuk mengambil data profil orang tua
  Future<void> fetchParentProfile() async {
    try {
      final result = await _authService.getProfile();
      if (result['success']) {
        parentName.value = result['data']['name'];
      }
    } catch (e) {
      print("Gagal memuat nama parent: $e");
    }
  }

  // Fungsi fetchBabysitters Anda sudah benar
  void fetchAvailabilities() async {
    try {
      isLoading(true);
      var availabilities =
          await BabysitterAvailabilityService.fetchAvailabilities();
      availabilityList.assignAll(availabilities);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data penawaran dari babysitter.');
    } finally {
      isLoading(false);
    }
  }

  // --- 4. FUNGSI BARU UNTUK MENGAMBIL DAFTAR ID FAVORIT ---
  Future<void> fetchFavoriteIds() async {
    try {
      // Panggil method yang sesuai dari FavoriteService
      // Pastikan Anda sudah membuat file favorite_service.dart
      var ids = await FavoriteService.getFavoriteIds();
      favoriteIds.assignAll(ids);
    } catch (e) {
      print("Gagal memuat data favorit: $e");
    }
  }

  // --- 5. FUNGSI BARU UNTUK MENAMBAH/MENGHAPUS FAVORIT ---
  void toggleFavorite(int babysitterId) async {
    // Optimistic UI Update: Langsung ubah ikon di UI tanpa menunggu respons server
    // agar aplikasi terasa instan dan responsif.
    if (favoriteIds.contains(babysitterId)) {
      favoriteIds.remove(babysitterId);
    } else {
      favoriteIds.add(babysitterId);
    }

    // Kirim permintaan ke server di latar belakang
    // Pastikan Anda sudah membuat method ini di FavoriteService
    var result = await FavoriteService.toggleFavorite(babysitterId);

    // Tampilkan notifikasi pop-up dari hasil API jika ada pesan
    if (result['message'] != null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: result['success'] ? DialogType.info : DialogType.error,
        animType: AnimType.scale,
        title: result['success'] ? 'Info' : 'Gagal',
        desc: result['message'],
        headerAnimationLoop: false,
        btnOkOnPress: () {},
      ).show();
    }

    // Jika gagal, kembalikan state UI ke semula agar konsisten dengan server
    if (!result['success']) {
      // Tunggu sejenak agar user bisa melihat state awal sebelum dibalikkan
      await Future.delayed(const Duration(milliseconds: 300));
      if (favoriteIds.contains(babysitterId)) {
        favoriteIds.remove(babysitterId);
      } else {
        favoriteIds.add(babysitterId);
      }
    }
  }
}
