import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:momy_butuh_flutter/app/data/services/joboffer_service.dart';
import 'package:momy_butuh_flutter/app/modules/profil/controllers/profile_controller.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class CreateJobOfferController extends GetxController {
  // --- Text Editing Controllers untuk setiap field di form ---
  final titleC = TextEditingController();
  final descriptionC = TextEditingController();
  final priceC = TextEditingController();
  final addressC = TextEditingController();
  // --- KODE BARU ---
  final dateC = TextEditingController();
  final startTimeC = TextEditingController();
  final endTimeC = TextEditingController();

  var isLoading = false.obs;
  var selectedLocation = Rxn<LatLng>();

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void onClose() {
    // Selalu bersihkan semua controller
    titleC.dispose();
    descriptionC.dispose();
    priceC.dispose();
    dateC.dispose();
    startTimeC.dispose();
    endTimeC.dispose();
    addressC.dispose();
    super.onClose();
  }

  // --- FUNGSI BARU UNTUK MEMILIH TANGGAL & WAKTU ---
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
  // --- BATAS FUNGSI BARU ---

  void updateLocation(LatLng location) {
    selectedLocation.value = location;
    addressC.text =
        'Lokasi dipilih: ${location.latitude.toStringAsFixed(5)}, ${location.longitude.toStringAsFixed(5)}';
  }

  void submitOffer() async {
    // 1. Validasi Sederhana di Sisi Klien
    if (titleC.text.isEmpty ||
        descriptionC.text.isEmpty ||
        priceC.text.isEmpty ||
        dateC.text.isEmpty ||
        startTimeC.text.isEmpty ||
        endTimeC.text.isEmpty ||
        selectedLocation.value == null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: 'Data Tidak Lengkap',
        desc: 'Mohon isi semua field yang tersedia.',
      ).show();
      return;
    }

    // --- 2. LOGIKA BARU: VALIDASI SALDO ---
    final offeredPrice = int.tryParse(priceC.text.replaceAll('.', '')) ?? 0;
    final currentBalance = profileController.userProfile.value?.balance ?? 0;

    if (currentBalance < offeredPrice) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Saldo Tidak Cukup',
        desc:
            'Saldo Anda saat ini (Rp ${NumberFormat('#,##0', 'id_ID').format(currentBalance)}) tidak mencukupi untuk harga yang Anda tawarkan.',
        btnOkOnPress: () {},
        btnOkColor: AppTheme.primaryColor,
      ).show();
      return; // Hentikan proses jika saldo tidak cukup
    }
    // --- BATAS LOGIKA BARU ---

    isLoading.value = true;

    Map<String, String> offerData = {
      'title': titleC.text,
      'description': descriptionC.text,
      'offered_price': offeredPrice.toString(),
      'location_address': addressC.text,
      'latitude': selectedLocation.value!.latitude.toString(),
      'longitude': selectedLocation.value!.longitude.toString(),
      'job_date': dateC.text,
      'start_time': startTimeC.text,
      'end_time': endTimeC.text,
    };

    var result = await JobOfferService.createOffer(offerData);
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
