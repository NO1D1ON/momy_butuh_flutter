import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import 'package:momy_butuh_flutter/app/data/services/booking_service.dart';
import 'package:momy_butuh_flutter/app/data/services/review_service.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart'; // Sesuaikan jika path theme berbeda

class BookingHistoryController extends GetxController {
  // Gunakan RxBool untuk status loading agar UI reaktif
  var isLoading = true.obs;
  // Gunakan RxList untuk menampung daftar booking
  var bookingList =
      <Booking>[].obs; // Pastikan 'Booking' adalah nama model Anda

  @override
  void onInit() {
    super.onInit();
    // Panggil fetchBookingHistory saat controller pertama kali dimuat
    fetchBookingHistory();
  }

  // Metode untuk mengambil data riwayat booking dari service/API
  void fetchBookingHistory() async {
    try {
      isLoading(true);
      // Panggil service untuk mendapatkan data booking
      var bookings = await BookingService.getMyBookings();
      // Masukkan semua data ke dalam bookingList
      bookingList.assignAll(bookings);
    } catch (e) {
      // Tampilkan pesan error jika gagal memuat data
      Get.snackbar(
        "Error",
        "Gagal memuat riwayat booking: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Hentikan status loading setelah selesai
      isLoading(false);
    }
  }

  // Metode untuk menyelesaikan pesanan (status 'confirmed' -> 'completed')
  void completeBooking(int bookingId) async {
    // Tampilkan dialog konfirmasi untuk memastikan tindakan pengguna
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.info,
      title: 'Konfirmasi Penyelesaian',
      desc:
          'Apakah Anda yakin ingin menyelesaikan pesanan ini? Saldo akan diteruskan ke babysitter.',
      btnCancelOnPress: () {}, // Tidak melakukan apa-apa jika dibatalkan
      btnOkOnPress: () async {
        // Panggil service setelah pengguna menekan OK
        var result = await BookingService.completeBooking(bookingId);

        // Tampilkan notifikasi berdasarkan hasil dari service
        AwesomeDialog(
          context: Get.context!,
          dialogType: result['success'] ? DialogType.success : DialogType.error,
          title: result['success'] ? 'Berhasil' : 'Gagal',
          desc: result['message'],
          btnOkOnPress: () {
            if (result['success']) {
              // Jika berhasil, muat ulang data untuk memperbarui status di UI
              fetchBookingHistory();
            }
          },
          // Ganti warna tombol sesuai kebutuhan
          btnOkColor: result['success'] ? Colors.green : AppTheme.primaryColor,
        ).show();
      },
    ).show();
  }

  // Fungsi untuk memproses pengiriman review
  void postReview(int bookingId, int rating, String comment) async {
    try {
      // Tampilkan dialog loading agar pengguna tahu proses sedang berjalan
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Panggil service untuk mengirim review
      var result = await ReviewService.postReview(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );

      Get.back(); // Tutup dialog loading

      // Tampilkan dialog hasil berdasarkan response dari service
      AwesomeDialog(
        context: Get.context!,
        dialogType: result['success'] ? DialogType.success : DialogType.error,
        title: result['success'] ? 'Sukses' : 'Gagal',
        desc: result['message'],
        btnOkOnPress: () {
          if (result['success']) {
            // Refresh daftar booking untuk memperbarui status review
            fetchBookingHistory();
          }
        },
      ).show();
    } catch (e) {
      Get.back(); // Pastikan dialog loading ditutup jika terjadi error
      // Tampilkan pesan error
      Get.snackbar(
        "Error",
        "Gagal mengirim ulasan: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
