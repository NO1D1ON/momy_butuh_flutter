import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/create_job_offer/controller.dart';

class CreateJobOfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateJobOfferController>(() => CreateJobOfferController());
  }
}
