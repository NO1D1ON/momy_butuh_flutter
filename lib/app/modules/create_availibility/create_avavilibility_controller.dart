import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_available_service.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class CreateAvailabilityController extends GetxController {
  // --- Text Editing Controllers ---
  final dateC = TextEditingController();
  final startTimeC = TextEditingController();
  final endTimeC = TextEditingController();
  final rateC = TextEditingController();
  final locationC = TextEditingController();
  final notesC = TextEditingController();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Secara otomatis mengambil lokasi saat halaman dibuka
    getCurrentLocation();
  }

  @override
  void onClose() {
    dateC.dispose();
    startTimeC.dispose();
    endTimeC.dispose();
    rateC.dispose();
    locationC.dispose();
    notesC.dispose();
    super.onClose();
  }

  // --- Fungsi untuk Mengambil Lokasi Terkini ---
  Future<void> getCurrentLocation() async {
    try {
      locationC.text = "Mencari alamat Anda...";
      Position position = await _determinePosition();

      try {
        // Coba lakukan reverse geocoding
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        // Jika berhasil mendapatkan alamat
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          locationC.text =
              "${place.street}, ${place.subLocality}, ${place.locality}";
        } else {
          // Jika tidak ada alamat ditemukan, gunakan fallback ke koordinat
          throw Exception('Alamat tidak ditemukan');
        }
      } catch (geocodingError) {
        // --- PERBAIKAN UTAMA DI SINI ---
        // Jika geocoding gagal, tampilkan koordinat sebagai gantinya
        print("Geocoding Gagal, menggunakan fallback: $geocodingError");
        locationC.text =
            "Lokasi saat ini: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}";
      }
    } catch (e) {
      // Jika error terjadi saat mendapatkan posisi GPS itu sendiri
      locationC.text = "Gagal mendapatkan lokasi.";
      Get.snackbar("Error Lokasi", e.toString());
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  // --- Fungsi untuk Memilih Tanggal & Waktu ---
  void pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (pickedDate != null) {
      dateC.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  void pickTime(bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      if (isStartTime) {
        startTimeC.text = formattedTime;
      } else {
        endTimeC.text = formattedTime;
      }
    }
  }

  // --- Fungsi untuk Mengirim Penawaran ---
  void submitAvailability() async {
    // Validasi sederhana di sisi klien
    if (dateC.text.isEmpty ||
        startTimeC.text.isEmpty ||
        endTimeC.text.isEmpty ||
        rateC.text.isEmpty) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: 'Data Tidak Lengkap',
        desc: 'Mohon isi tanggal, jam mulai, jam selesai, dan tarif per jam.',
      ).show();
      return;
    }

    isLoading.value = true;

    Map<String, String> availabilityData = {
      'available_date': dateC.text,
      'start_time': startTimeC.text,
      'end_time': endTimeC.text,
      'rate_per_hour': rateC.text.replaceAll('.', ''),
      'location_preference': locationC.text,
      'notes': notesC.text,
    };

    var result = await BabysitterAvailabilityService.createAvailability(
      availabilityData,
    );
    isLoading.value = false;

    AwesomeDialog(
      context: Get.context!,
      dialogType: result['success'] ? DialogType.success : DialogType.error,
      title: result['success'] ? 'Berhasil' : 'Gagal',
      desc: result['message'],
      btnOkOnPress: () {
        if (result['success']) {
          // Ganti Get.back() menjadi Get.offAllNamed()
          // untuk kembali ke dashboard utama babysitter.
          Get.offAllNamed(Routes.DASHBOARD_BABYSITTER);
        }
      },
      btnOkColor: result['success'] ? Colors.green : AppTheme.primaryColor,
    ).show();
  }
}
