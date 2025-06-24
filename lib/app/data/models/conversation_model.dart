// Model untuk data satu baris percakapan
class Conversation {
  final int id;
  final int userId;
  final int babysitterId;
  final String babysitterName;
  // Kita bisa tambahkan lastMessage di sini nanti

  Conversation({
    required this.id,
    required this.userId,
    required this.babysitterId,
    required this.babysitterName,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      userId: json['user_id'],
      babysitterId: json['babysitter_id'],
      // Ambil nama dari data relasi 'babysitter'
      babysitterName: json['babysitter'] != null
          ? json['babysitter']['name']
          : 'N/A',
    );
  }
}
