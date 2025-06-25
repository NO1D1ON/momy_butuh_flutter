import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/transaction_history/controller.dart';

class TransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionHistoryController>(
      () => TransactionHistoryController(),
    );
  }
}
