class Conversation {
  final int conversationId;
  final int otherPartyId;
  final String otherPartyName;
  final String lastMessage;
  final String lastMessageTime;

  Conversation({
    required this.conversationId,
    required this.otherPartyId,
    required this.otherPartyName,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani angka yang dikirim sebagai String.
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      // Mengonversi 'conversation_id' dengan aman.
      conversationId: int.tryParse(json['conversation_id'].toString()) ?? 0,

      // Mengonversi 'other_party_id' dengan aman.
      otherPartyId: int.tryParse(json['other_party_id'].toString()) ?? 0,

      // Parsing untuk String sudah aman dengan nilai default.
      otherPartyName: json['other_party_name'] ?? 'Unknown User',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
    );
  }
}
