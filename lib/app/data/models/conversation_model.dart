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

  // Factory constructor untuk membuat instance dari JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversation_id'] ?? 0,
      otherPartyId: json['other_party_id'] ?? 0,
      otherPartyName: json['other_party_name'] ?? 'Unknown User',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
    );
  }
}
