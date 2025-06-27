import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_search/controller.dart';

class BabysitterSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BabysitterSearchController>(() => BabysitterSearchController());
  }
}
