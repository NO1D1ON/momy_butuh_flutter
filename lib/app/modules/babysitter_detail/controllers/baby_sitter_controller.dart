import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// Sesuaikan path jika perlu
import '../../../data/models/babysitter_model.dart';
import '../../../data/models/babysitter_availibility_model.dart';
import '../../../data/services/babysitter_service.dart';
import '../../../data/services/babysitter_available_service.dart';

class BabysitterDetailController extends GetxController {
  // State untuk menampung data
  var babysitter = Rxn<Babysitter>();
  var babysitterAvailability = Rxn<BabysitterAvailability>();

  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final dynamic arguments = Get.arguments;

    // Logika baru untuk menangani berbagai tipe argumen
    if (arguments is BabysitterAvailability) {
      // Skenario 1: Data lengkap dari Peta atau Beranda
      _loadFromAvailabilityObject(arguments);
    } else if (arguments is int) {
      // Skenario 2: Hanya ID dari Pencarian atau Favorit
      _fetchDetailsById(arguments);
    } else {
      _handleInvalidArguments();
    }
  }

  // Metode untuk memuat data dari object yang sudah ada
  void _loadFromAvailabilityObject(BabysitterAvailability availability) {
    isLoading(true);
    babysitterAvailability.value = availability;
    // Ambil data babysitter dari dalam object availability
    babysitter.value = availability.babysitter;
    isLoading(false);
  }

  // Metode baru untuk fetch data lengkap berdasarkan ID
  Future<void> _fetchDetailsById(int id) async {
    try {
      isLoading(true);
      errorMessage('');
      // 1. Ambil detail profil babysitter
      final fetchedBabysitter = await BabysitterService.fetchBabysitterDetail(
        id,
      );
      if (fetchedBabysitter != null) {
        babysitter.value = fetchedBabysitter;
        // 2. (Opsional tapi direkomendasikan) Coba cari jadwal aktifnya juga
        // Ini akan membuat tombol "Booking" tetap berfungsi dengan tarif yang benar
        final allAvailabilities =
            await BabysitterAvailabilityService.fetchAvailabilities();
        final activeAvailability = allAvailabilities.firstWhereOrNull(
          (avail) => avail.babysitter.id == id && _isShiftActive(avail),
        );
        babysitterAvailability.value = activeAvailability;
      } else {
        throw Exception("Babysitter dengan ID $id tidak ditemukan.");
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading(false);
    }
  }

  // Helper untuk mengecek apakah shift sedang aktif
  bool _isShiftActive(BabysitterAvailability avail) {
    final now = DateTime.now();
    final todayDateString = DateFormat('yyyy-MM-dd').format(now);
    if (avail.availableDate != todayDateString) return false;
    try {
      final startTime = DateFormat("HH:mm:ss").parse(avail.startTime);
      final endTime = DateFormat("HH:mm:ss").parse(avail.endTime);
      final currentTime = TimeOfDay.fromDateTime(now);
      final startTOD = TimeOfDay(
        hour: startTime.hour,
        minute: startTime.minute,
      );
      final endTOD = TimeOfDay(hour: endTime.hour, minute: endTime.minute);

      // Konversi ke menit untuk perbandingan yang mudah
      final nowInMinutes = currentTime.hour * 60 + currentTime.minute;
      final startInMinutes = startTOD.hour * 60 + startTOD.minute;
      final endInMinutes = endTOD.hour * 60 + endTOD.minute;

      if (startInMinutes <= endInMinutes) {
        return nowInMinutes >= startInMinutes && nowInMinutes < endInMinutes;
      } else {
        // Handle shift yang melewati tengah malam
        return nowInMinutes >= startInMinutes || nowInMinutes < endInMinutes;
      }
    } catch (e) {
      return false;
    }
  }

  void _handleInvalidArguments() {
    isLoading.value = false;
    errorMessage.value = "Gagal memuat: Data Babysitter tidak valid.";
    Get.snackbar("Error", "Argumen navigasi tidak valid.");
  }

  // Getter untuk UI, sekarang lebih aman
  Babysitter? get currentBabysitter => babysitter.value;
  BabysitterAvailability? get currentAvailability =>
      babysitterAvailability.value;

  String get displayName =>
      currentAvailability?.name ??
      currentBabysitter?.name ??
      'Nama tidak tersedia';
  String? get displayPhotoUrl =>
      currentAvailability?.photoUrl ?? currentBabysitter?.photoUrl;
  int get displayAge => currentAvailability?.age ?? currentBabysitter?.age ?? 0;
  double get displayRating =>
      currentAvailability?.rating ?? currentBabysitter?.rating ?? 0.0;
}
