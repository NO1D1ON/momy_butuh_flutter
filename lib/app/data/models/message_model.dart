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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      senderType: json['sender_type'],
      body: json['body'],
      createdAt: json['created_at'],
    );
  }
}
