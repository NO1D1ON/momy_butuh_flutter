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
}
