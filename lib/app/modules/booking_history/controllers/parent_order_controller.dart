import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import 'package:momy_butuh_flutter/app/data/models/joboffer_model.dart';
import 'package:momy_butuh_flutter/app/data/services/joboffer_service.dart';
import '../../../data/services/booking_service.dart';

class ParentOrdersController extends GetxController {
  // State untuk setiap tab
  var myBookings = <Booking>[].obs;
  var myJobOffers = <JobOffer>[].obs;
  var isLoadingBookings = true.obs;
  var isLoadingOffers = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyBookings();
    fetchMyJobOffers();
  }

  void fetchMyBookings() async {
    try {
      isLoadingBookings(true);
      var result = await BookingService.getMyBookings();
      myBookings.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat riwayat booking.");
    } finally {
      isLoadingBookings(false);
    }
  }

  void fetchMyJobOffers() async {
    try {
      isLoadingOffers(true);
      // Anda perlu menambahkan method ini di JobOfferService
      var result = await JobOfferService.fetchMyJobOffers();
      myJobOffers.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat penawaran Anda.");
    } finally {
      isLoadingOffers(false);
    }
  }
}
