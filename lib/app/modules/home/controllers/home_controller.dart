import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:momy_butuh_flutter/app/data/models/babysitter_availibility_model.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_available_service.dart';
import 'package:momy_butuh_flutter/app/modules/notification/notfication_controller.dart';
import 'package:momy_butuh_flutter/app/data/services/favorite_service.dart';

class HomeController extends GetxController {
  // === STATE MANAGEMENT ===
  var parentName = "Orang Tua".obs;
  var isLoading = true.obs;
  var availabilityList = <BabysitterAvailability>[].obs;
  var favoriteIds =
      <int>{}.obs; // Menggunakan Set untuk efisiensi dan data unik
  var unreadNotifications = 0.obs;

  // === SERVICE DEPENDENCIES ===
  // Menggunakan Dependency Injection dari GetX
  final AuthService _authService = Get.find<AuthService>();
  late final NotificationController _notificationController;

  @override
  void onInit() {
    super.onInit();
    // 1. Daftarkan dan temukan NotificationController
    // Ini memastikan controller notifikasi siap digunakan dan state-nya bisa dipantau.
    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut(() => NotificationController());
    }
    _notificationController = Get.find<NotificationController>();

    // 2. Pantau perubahan pada daftar notifikasi untuk update badge secara reaktif
    ever(_notificationController.notifications, (_) => _updateUnreadCount());
  }

  @override
  void onReady() {
    super.onReady();
    // 3. Panggil data awal di onReady() untuk memastikan lifecycle aman
    fetchInitialData();
  }

  /// Fungsi utama untuk memuat semua data yang diperlukan halaman home.
  void fetchInitialData() async {
    // Mengelola state loading secara terpusat
    isLoading(true);
    // Memuat data secara sekuensial untuk menghindari race condition
    await fetchParentProfile();
    await fetchAvailabilities();
    await fetchFavoriteIds();
    _updateUnreadCount(); // Update hitungan notifikasi setelah semua data dimuat
    isLoading(false);
  }

  /// Mengupdate jumlah notifikasi yang belum dibaca.
  void _updateUnreadCount() {
    unreadNotifications.value = _notificationController.notifications
        .where((notification) => !notification.isRead)
        .length;
  }

  /// Mengambil data profil (nama) orang tua dari server.
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

  /// Mengambil daftar ketersediaan dari para babysitter.
  Future<void> fetchAvailabilities() async {
    try {
      var availabilities =
          await BabysitterAvailabilityService.fetchAvailabilities();
      availabilityList.assignAll(availabilities);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data penawaran dari babysitter.');
    }
  }

  /// Mengambil daftar ID babysitter yang sudah difavoritkan.
  Future<void> fetchFavoriteIds() async {
    try {
      var ids = await FavoriteService.getFavoriteIds();
      favoriteIds.assignAll(ids);
    } catch (e) {
      print("Gagal memuat data favorit: $e");
    }
  }

  /// Menambah atau menghapus babysitter dari daftar favorit.
  void toggleFavorite(int babysitterId) async {
    // Optimistic UI: UI diupdate langsung untuk respons yang instan.
    final isCurrentlyFavorite = favoriteIds.contains(babysitterId);
    if (isCurrentlyFavorite) {
      favoriteIds.remove(babysitterId);
    } else {
      favoriteIds.add(babysitterId);
    }

    // Kirim permintaan ke server.
    try {
      var result = await FavoriteService.toggleFavorite(babysitterId);

      // Jika gagal, kembalikan state UI ke kondisi semula.
      if (!result['success']) {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal mengubah status favorit.',
        );
        if (isCurrentlyFavorite) {
          favoriteIds.add(babysitterId);
        } else {
          favoriteIds.remove(babysitterId);
        }
      }
    } catch (e) {
      // Handle network error etc.
      Get.snackbar('Error', 'Terjadi kesalahan. Periksa koneksi Anda.');
      if (isCurrentlyFavorite) {
        favoriteIds.add(babysitterId);
      } else {
        favoriteIds.remove(babysitterId);
      }
    }
  }
}
