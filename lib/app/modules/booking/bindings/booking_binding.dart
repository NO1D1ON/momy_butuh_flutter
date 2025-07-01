import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/profil/controllers/profile_controller.dart';
import '../controllers/booking_controller.dart';

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingController>(() => BookingController());

    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
