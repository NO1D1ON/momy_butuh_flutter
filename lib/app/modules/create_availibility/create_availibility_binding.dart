import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/create_availibility/create_avavilibility_controller.dart';

class CreateAvailabilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAvailabilityController>(
      () => CreateAvailabilityController(),
    );
  }
}
