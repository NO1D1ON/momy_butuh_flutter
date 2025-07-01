import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import 'package:momy_butuh_flutter/app/data/services/booking_service.dart';
import 'package:momy_butuh_flutter/app/data/services/review_service.dart';
import 'package:momy_butuh_flutter/app/utils/theme.dart';

class BookingHistoryController extends GetxController {
  var isLoading = true.obs;

  // Menggunakan tiga daftar terpisah untuk setiap status booking
  // agar lebih mudah dikelola di UI dengan TabView.
  var pendingBookings = <Booking>[].obs;
  var ongoingBookings = <Booking>[].obs;
  var completedBookings = <Booking>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingHistory();
  }

  /// Mengambil data dari service dan mengelompokkannya ke dalam tiga daftar status.
  void fetchBookingHistory() async {
    try {
      isLoading(true);
      var allBookings = await BookingService.getMyBookings();

      // Kosongkan list terlebih dahulu untuk menghindari data ganda saat refresh.
      pendingBookings.clear();
      ongoingBookings.clear();
      completedBookings.clear();

      // Kelompokkan setiap booking ke dalam daftar yang sesuai berdasarkan statusnya.
      for (var booking in allBookings) {
        switch (booking.status) {
          case 'pending':
            pendingBookings.add(booking);
            break;
          case 'confirmed':
          case 'babysitter_confirmed': // Status ini dianggap sedang berjalan.
            ongoingBookings.add(booking);
            break;
          case 'completed':
          case 'parent_confirmed': // Status ini dianggap sudah selesai dari sisi parent.
          case 'rejected':
          case 'canceled':
            completedBookings.add(booking);
            break;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat riwayat booking: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Fungsi untuk konfirmasi penyelesaian pekerjaan dari sisi orang tua.
  void confirmAsParent(int bookingId) {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Konfirmasi Penyelesaian',
      desc:
          'Apakah Anda yakin pekerjaan ini sudah selesai? Tindakan ini akan memproses pembayaran ke babysitter jika babysitter juga sudah mengkonfirmasi.',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        // Tampilkan dialog loading selama proses berjalan.
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        var result = await BookingService.parentConfirmBooking(bookingId);

        Get.back(); // Tutup dialog loading.

        AwesomeDialog(
          context: Get.context!,
          dialogType: result['success'] ? DialogType.success : DialogType.error,
          title: result['success'] ? 'Berhasil' : 'Gagal',
          desc: result['message'],
          btnOkOnPress: () {
            if (result['success']) {
              // Muat ulang data untuk memperbarui tampilan di UI.
              fetchBookingHistory();
            }
          },
        ).show();
      },
    ).show();
  }

  /// Fungsi untuk mengirim atau memperbarui ulasan.
  void postReview(int bookingId, int rating, String comment) async {
    try {
      // Tampilkan dialog loading agar pengguna tahu proses sedang berjalan.
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      var result = await ReviewService.postReview(
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );

      Get.back(); // Tutup dialog loading.

      AwesomeDialog(
        context: Get.context!,
        dialogType: result['success'] ? DialogType.success : DialogType.error,
        title: result['success'] ? 'Sukses' : 'Gagal',
        desc:
            result['message'] ??
            (result['success']
                ? 'Ulasan Anda telah disimpan.'
                : 'Gagal menyimpan ulasan.'),
        btnOkOnPress: () {
          if (result['success']) {
            // Refresh daftar booking untuk memperbarui status ulasan (misal: tombol review hilang).
            fetchBookingHistory();
          }
        },
      ).show();
    } catch (e) {
      Get.back(); // Pastikan dialog loading ditutup jika terjadi eror.
      Get.snackbar(
        "Error",
        "Gagal mengirim ulasan: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
