import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import 'package:momy_butuh_flutter/app/data/models/joboffer_model.dart';
import 'package:momy_butuh_flutter/app/data/services/babysitter_booking_service.dart';
import 'package:momy_butuh_flutter/app/data/services/joboffer_service.dart';

class BabysitterBookingsController extends GetxController {
  // State untuk data
  var upcomingBookings = <Booking>[].obs;
  var completedBookings = <Booking>[].obs;
  var jobOffers = <JobOffer>[].obs;

  // State untuk UI
  var isLoadingBookings = true.obs;
  var isLoadingOffers = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil kedua fungsi untuk memuat data
    fetchMyBookings();
    fetchJobOffers();
  }

  /// Mengambil riwayat booking dan memisahkannya
  void fetchMyBookings() async {
    try {
      isLoadingBookings(true);
      var allBookings = await BabysitterBookingService.getMyBookings();

      // Pisahkan daftar booking berdasarkan status
      upcomingBookings.assignAll(
        allBookings.where((b) => b.status == 'confirmed'),
      );
      completedBookings.assignAll(
        allBookings.where((b) => b.status == 'completed'),
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat booking Anda.");
    } finally {
      isLoadingBookings(false);
    }
  }

  /// Mengambil daftar penawaran terbuka
  void fetchJobOffers() async {
    try {
      isLoadingOffers(true);
      var offers = await JobOfferService.fetchJobOffers();
      jobOffers.assignAll(offers);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat penawaran terbuka.");
    } finally {
      isLoadingOffers(false);
    }
  }

  void confirmAsBabysitter(int bookingId) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Konfirmasi Penyelesaian',
      desc: 'Apakah Anda yakin pekerjaan ini sudah selesai?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        // Tampilkan loading indicator
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        var result = await BabysitterBookingService.babysitterConfirmBooking(
          bookingId,
        );

        Get.back(); // Tutup loading indicator

        // --- PERBAIKAN UTAMA DI SINI ---
        // Cek jika 'success' adalah true DAN 'data' tidak null
        if (result['success'] == true && result['data'] != null) {
          final responseData = result['data'] as Map<String, dynamic>;
          final status = responseData['status'];
          final message = responseData['message'];

          AwesomeDialog(
            context: Get.context!,
            dialogType: status == 'completed'
                ? DialogType.success
                : DialogType.info,
            title: status == 'completed'
                ? 'Pesanan Selesai!'
                : 'Menunggu Konfirmasi',
            desc: message,
            btnOkOnPress: () {
              fetchMyBookings(); // Muat ulang data untuk memperbarui tampilan
            },
          ).show();
        } else {
          // Jika gagal, tampilkan pesan error dari kunci 'message'
          AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.error,
            title: 'Gagal',
            desc:
                result['message'] ?? 'Terjadi kesalahan yang tidak diketahui.',
            btnOkOnPress: () {},
          ).show();
        }
      },
    ).show();
  }
}
