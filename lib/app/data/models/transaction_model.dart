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

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani angka yang dikirim sebagai String.
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: json['type'] ?? 'N/A',
      description: json['description'] ?? 'Tanpa deskripsi',

      // Mengonversi 'amount' dengan aman, baik itu String, int, atau null.
      amount: int.tryParse(json['amount'].toString()) ?? 0,

      // 'is_credit' umumnya dikirim sebagai boolean (0 atau 1),
      // namun pengecekan ini membuatnya lebih aman.
      isCredit: json['is_credit'] == true || json['is_credit'] == 1,

      // Mengonversi tanggal dengan aman.
      date: json['date'] != null
          ? DateTime.tryParse(json['date']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
