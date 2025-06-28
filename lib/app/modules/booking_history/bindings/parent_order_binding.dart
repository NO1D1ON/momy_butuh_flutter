import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/booking_history/controllers/parent_order_controller.dart';

class ParentOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentOrdersController>(() => ParentOrdersController());
  }
}
