import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/booking_service.dart';
import '../../../utils/theme.dart';

class BookingController extends GetxController {
  late final Babysitter babysitter;
  var isLoading = false.obs;

  // State untuk menyimpan tanggal dan waktu yang dipilih
  var selectedDate = Rxn<DateTime>();
  var startTime = Rxn<TimeOfDay>();
  var endTime = Rxn<TimeOfDay>();
  var totalPrice = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data babysitter yang dikirim dari halaman detail
    babysitter = Get.arguments;
  }

  // Fungsi untuk menampilkan date picker
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

  // Fungsi untuk menampilkan time picker
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

  // Fungsi untuk menghitung total harga
  void calculatePrice() {
    if (startTime.value != null && endTime.value != null) {
      final start = startTime.value!;
      final end = endTime.value!;
      // Hitung durasi dalam jam
      final duration =
          (end.hour - start.hour) + (end.minute - start.minute) / 60.0;
      if (duration > 0) {
        totalPrice.value = (duration * babysitter.ratePerHour).ceil();
      } else {
        totalPrice.value = 0;
      }
    }
  }

  // Fungsi untuk konfirmasi booking
  void confirmBooking() async {
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

    isLoading.value = true;
    final result = await BookingService.createBooking(
      babysitterId: babysitter.id,
      bookingDate: DateFormat('yyyy-MM-dd').format(selectedDate.value!),
      startTime:
          '${startTime.value!.hour.toString().padLeft(2, '0')}:${startTime.value!.minute.toString().padLeft(2, '0')}',
      endTime:
          '${endTime.value!.hour.toString().padLeft(2, '0')}:${endTime.value!.minute.toString().padLeft(2, '0')}',
    );
    isLoading.value = false;

    if (result['success']) {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.success,
        title: 'Booking Berhasil',
        desc: result['message'],
        btnOkOnPress: () => Get.back(), // Kembali ke halaman detail setelah OK
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
