import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_detail/controllers/baby_sitter_controller.dart';

class BabysitterDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BabysitterDetailController>(() => BabysitterDetailController());
  }
}
