import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/map_picker/controller.dart';

class MapPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapPickerController>(() => MapPickerController());
  }
}
