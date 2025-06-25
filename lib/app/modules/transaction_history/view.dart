import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:momy_butuh_flutter/app/modules/transaction_history/controller.dart';

class TransactionHistoryView extends GetView<TransactionHistoryController> {
  const TransactionHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Transaksi")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.transactionList.isEmpty) {
          return const Center(child: Text("Belum ada riwayat transaksi."));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.transactionList.length,
          itemBuilder: (context, index) {
            final transaction = controller.transactionList[index];
            final isCredit = transaction.isCredit;
            final color = isCredit ? Colors.green : Colors.red;
            final icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
            final prefix = isCredit ? '+ ' : '- ';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color),
                ),
                title: Text(
                  transaction.type,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  transaction.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      prefix +
                          "Rp ${NumberFormat('#,##0', 'id_ID').format(transaction.amount)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      DateFormat(
                        'd MMM y, HH:mm',
                      ).format(transaction.date.toLocal()),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
