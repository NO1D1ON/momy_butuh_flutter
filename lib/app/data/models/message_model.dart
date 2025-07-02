class Message {
  final int id;
  final int senderId;
  final String senderType;
  final String body;
  final String createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.senderType,
    required this.body,
    required this.createdAt,
  });

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani angka yang dikirim sebagai String.
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      // Mengonversi 'id' dengan aman, memberikan nilai default 0 jika null atau gagal.
      id: int.tryParse(json['id'].toString()) ?? 0,

      // Mengonversi 'sender_id' dengan aman.
      senderId: int.tryParse(json['sender_id'].toString()) ?? 0,

      // Memberikan nilai default untuk field String jika null.
      senderType: json['sender_type'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
