import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/select_location/controller.dart';

class SelectLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectLocationController>(() => SelectLocationController());
  }
}
