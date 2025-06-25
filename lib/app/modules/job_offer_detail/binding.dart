import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/job_offer_detail/controller.dart';

class JobOfferDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobOfferDetailController>(() => JobOfferDetailController());
  }
}
