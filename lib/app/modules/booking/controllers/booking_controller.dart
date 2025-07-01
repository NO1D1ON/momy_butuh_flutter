// lib/app/modules/booking/controllers/booking_controller.dart

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:momy_butuh_flutter/app/data/models/babysitter_availibility_model.dart';
import 'package:momy_butuh_flutter/app/modules/profil/controllers/profile_controller.dart';
import 'package:momy_butuh_flutter/app/routes/app_pages.dart';
import '../../../data/services/booking_service.dart';
import '../../../utils/theme.dart';

class BookingController extends GetxController {
  // PERUBAHAN 1: Terima BabysitterAvailability, bukan Babysitter
  late final BabysitterAvailability availability;

  var isLoading = false.obs;
  var selectedDate = Rxn<DateTime>();
  var startTime = Rxn<TimeOfDay>();
  var endTime = Rxn<TimeOfDay>();
  var totalPrice = 0.obs;

  // Ambil ProfileController untuk cek saldo
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    // Ambil data availability dari argumen
    availability = Get.arguments;
  }

  void pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate != null) {
      selectedDate.value = pickedDate;
      calculatePrice();
    }
  }

  void pickTime(BuildContext context, {required bool isStartTime}) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      if (isStartTime) {
        startTime.value = pickedTime;
      } else {
        endTime.value = pickedTime;
      }
      calculatePrice();
    }
  }

  void calculatePrice() {
    if (startTime.value != null &&
        endTime.value != null &&
        selectedDate.value != null) {
      final date = selectedDate.value!;
      final startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        startTime.value!.hour,
        startTime.value!.minute,
      );
      var endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        endTime.value!.hour,
        endTime.value!.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }

      final differenceInMinutes = endDateTime
          .difference(startDateTime)
          .inMinutes;

      if (differenceInMinutes > 0) {
        // PERBAIKAN 2: Gunakan tarif dari object availability
        final rate = availability.ratePerHour;
        final durationInHours = differenceInMinutes / 60.0;
        totalPrice.value = (durationInHours * rate).ceil();
      } else {
        totalPrice.value = 0;
      }
    }
  }

  void confirmBooking() async {
    // Validasi input dasar
    if (selectedDate.value == null ||
        startTime.value == null ||
        endTime.value == null) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: 'Data Belum Lengkap',
        desc: 'Silakan pilih tanggal dan waktu terlebih dahulu.',
      ).show();
      return;
    }

    // --- LOGIKA BARU DITAMBAHKAN DI SINI ---

    // 1. Validasi Saldo
    final currentBalance = profileController.userProfile.value?.balance ?? 0;
    if (currentBalance < totalPrice.value) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        title: 'Saldo Tidak Cukup',
        desc:
            'Saldo Anda (Rp ${NumberFormat('#,##0', 'id_ID').format(currentBalance)}) tidak mencukupi untuk melakukan booking ini.',
        btnOkText: "Top Up",
        btnOkOnPress: () => Get.toNamed(Routes.TOPUP),
        btnCancelText: "Batal",
        btnCancelOnPress: () {},
      ).show();
      return;
    }

    // 2. Validasi Jadwal
    final availabilityEndDate = DateTime.parse(availability.availableDate);
    final availabilityEndTimeParts = availability.endTime.split(':');
    final availabilityEndDateTime = DateTime(
      availabilityEndDate.year,
      availabilityEndDate.month,
      availabilityEndDate.day,
      int.parse(availabilityEndTimeParts[0]),
      int.parse(availabilityEndTimeParts[1]),
    );

    final selectedEndDateTime = DateTime(
      selectedDate.value!.year,
      selectedDate.value!.month,
      selectedDate.value!.day,
      endTime.value!.hour,
      endTime.value!.minute,
    );

    if (selectedEndDateTime.isAfter(availabilityEndDateTime)) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.warning,
        title: 'Jadwal Tidak Valid',
        desc:
            'Waktu selesai booking Anda melebihi jadwal yang tersedia dari babysitter.',
      ).show();
      return;
    }

    // --- AKHIR LOGIKA BARU ---

    isLoading.value = true;
    final result = await BookingService.createBooking(
      babysitterId: availability.babysitter.id, // Ambil id dari nested object
      bookingDate: DateFormat('yyyy-MM-dd').format(selectedDate.value!),
      startTime:
          '${startTime.value!.hour.toString().padLeft(2, '0')}:${startTime.value!.minute.toString().padLeft(2, '0')}',
      endTime:
          '${endTime.value!.hour.toString().padLeft(2, '0')}:${endTime.value!.minute.toString().padLeft(2, '0')}',
    );
    isLoading.value = false;

    if (result['success']) {
      // PERBAIKAN 3: Ubah notifikasi menjadi 'menunggu persetujuan'
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.info, // Ganti dari success ke info
        title: 'Permintaan Terkirim',
        desc:
            'Permintaan booking Anda berhasil diproses dan sedang menunggu persetujuan dari babysitter.',
        btnOkOnPress: () =>
            Get.offAllNamed(Routes.HOME), // Kembali ke halaman utama
      ).show();
    } else {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.error,
        title: 'Booking Gagal',
        desc: result['message'],
        btnOkOnPress: () {},
        btnOkColor: AppTheme.primaryColor,
      ).show();
    }
  }
}
