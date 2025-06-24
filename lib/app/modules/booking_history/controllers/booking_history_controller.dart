import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import '../../../data/services/booking_service.dart';
import '../../../data/services/review_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';

class BookingHistoryController extends GetxController {
  var isLoading = true.obs;
  var bookingList = <Booking>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingHistory();
  }

  void fetchBookingHistory() async {
    try {
      isLoading(true);
      var bookings = await BookingService.getMyBookings();
      bookingList.assignAll(bookings);
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk memproses pengiriman review
  void postReview(int bookingId, int rating, String comment) async {
    var result = await ReviewService.postReview(
      bookingId: bookingId,
      rating: rating,
      comment: comment,
    );

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
  }
}
