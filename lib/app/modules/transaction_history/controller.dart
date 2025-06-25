import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/transaction_model.dart';
import 'package:momy_butuh_flutter/app/data/services/transaction_service.dart';

class TransactionHistoryController extends GetxController {
  var isLoading = true.obs;
  var transactionList = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void fetchTransactions() async {
    try {
      isLoading(true);
      var transactions = await TransactionService.getTransactionHistory();
      transactionList.assignAll(transactions);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
