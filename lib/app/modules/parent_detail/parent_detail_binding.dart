import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/parent_detail/parent_detail_controller.dart';

class ParentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentDetailController>(() => ParentDetailController());
  }
}
