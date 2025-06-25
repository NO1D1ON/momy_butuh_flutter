class Transaction {
  final String type;
  final String description;
  final int amount;
  final bool isCredit; // true jika Top Up, false jika Pembayaran
  final DateTime date;

  Transaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.isCredit,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'] ?? 'N/A',
      description: json['description'] ?? 'Tanpa deskripsi',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      isCredit: json['is_credit'] ?? false,
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
    );
  }
}
