import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/bookinig_model.dart';
import 'package:momy_butuh_flutter/app/data/models/user_model.dart';
import 'package:momy_butuh_flutter/app/data/services/booking_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentDetailController extends GetxController {
  final Booking booking = Get.arguments;
  final BookingService _bookingService = BookingService();

  var isLoading = true.obs;
  var parentProfile = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchParentDetails();
  }

  Future<void> fetchParentDetails() async {
    try {
      isLoading(true);
      if (booking.parentId != 0) {
        // Cek ID tidak 0 atau null
        final profile = await BookingService.fetchParentProfileById(
          booking.parentId,
        );
        parentProfile.value = profile;
      } else {
        throw Exception("Parent ID tidak ditemukan pada data booking.");
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data pemesan: ${e.toString()}');
      parentProfile.value = null;
    } finally {
      isLoading(false);
    }
  }

  void openMap(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      Get.snackbar('Error', 'Koordinat lokasi tidak tersedia.');
      return;
    }
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka aplikasi peta.');
    }
  }
}
