import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:momy_butuh_flutter/app/data/services/joboffer_service.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class CreateJobOfferController extends GetxController {
  // --- Text Editing Controllers untuk setiap field di form ---
  final titleC = TextEditingController();
  final descriptionC = TextEditingController();
  final priceC = TextEditingController();
  final dateC = TextEditingController();
  final startTimeC = TextEditingController();
  final endTimeC = TextEditingController();
  final addressC = TextEditingController();

  // --- State Management ---
  var isLoading = false.obs;

  // --- STATE BARU UNTUK LOKASI ---
  // Gunakan Rxn agar bisa menampung nilai null di awal
  var selectedLocation = Rxn<LatLng>();

  @override
  void onClose() {
    // ... (method onClose yang sudah ada) ...
    super.onClose();
  }

  // ... (method pickDate dan pickTime yang sudah ada) ...

  // --- METHOD BARU UNTUK MEMPERBARUI LOKASI ---
  void updateLocation(LatLng location) {
    selectedLocation.value = location;
    // Anda juga bisa menambahkan logika untuk mengubah LatLng menjadi alamat
    // menggunakan paket geocoding dan mengisinya ke addressC
    addressC.text =
        'Lokasi dipilih dari peta (${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)})';
  }

  // --- Fungsi utama untuk mengirim penawaran ---
  void submitOffer() async {
    // ... (logika validasi sederhana yang sudah ada) ...

    // Pastikan lokasi sudah dipilih
    if (selectedLocation.value == null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: "Lokasi Belum Dipilih",
        desc: "Mohon pilih lokasi pekerjaan di peta.",
      ).show();
      return;
    }

    isLoading.value = true;

    Map<String, String> offerData = {
      'title': titleC.text,
      'description': descriptionC.text,
      'offered_price': priceC.text,
      'job_date': dateC.text,
      'start_time': startTimeC.text,
      'end_time': endTimeC.text,
      'location_address': addressC.text,
      'latitude': selectedLocation.value!.latitude
          .toString(), // Ambil dari state
      'longitude': selectedLocation.value!.longitude
          .toString(), // Ambil dari state
    };

    // 3. Panggil service untuk mengirim data
    var result = await JobOfferService.createOffer(offerData);

    // Sembunyikan loading indicator
    isLoading.value = false;

    // 4. Tampilkan notifikasi berdasarkan hasil dari API
    AwesomeDialog(
      context: Get.context!,
      dialogType: result['success'] ? DialogType.success : DialogType.error,
      animType: AnimType.scale,
      title: result['success'] ? 'Berhasil' : 'Gagal',
      desc: result['message'],
      btnOkOnPress: () {
        if (result['success']) {
          // Jika berhasil, kembali ke halaman sebelumnya (dashboard orang tua)
          Get.back();
        }
      },
      btnOkColor: result['success'] ? Colors.green : AppTheme.primaryColor,
    ).show();
  }
}
