import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/modules/ujiCobaChatRealTime/babysitter_list.dart';
import 'package:momy_butuh_flutter/app/modules/ujiCobaChatRealTime/chatScreen.dart';
import '../../utils/constants.dart'; // Sesuaikan path

// Model untuk menampung data percakapan
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

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversation_id'],
      otherPartyId: json['other_party_id'],
      otherPartyName: json['other_party_name'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
    );
  }
}

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({Key? key}) : super(key: key);

  @override
  _ConversationListScreenState createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  final AuthService _authService = AuthService();
  late Future<List<Conversation>> _conversationsFuture;

  @override
  void initState() {
    super.initState();
    _conversationsFuture = _fetchConversations();
  }

  Future<List<Conversation>> _fetchConversations() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Token not found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/conversations'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Conversation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load conversations: ${response.body}');
    }
  }

  // Di dalam ConversationListScreen, ubah _navigateToChat
  void _navigateToChat(Conversation conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          conversationId: conversation.conversationId,
          otherPartyName: conversation.otherPartyName,
          otherPartyId: conversation.otherPartyId,
          // SEDIAKAN INSTANCE AuthService YANG ASLI DI SINI
          authService: AuthService(),
          httpClient: http.Client(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesan')),
      body: FutureBuilder<List<Conversation>>(
        future: _conversationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada percakapan.'));
          }

          final conversations = snapshot.data!;
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final convo = conversations[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(convo.otherPartyName.substring(0, 1)),
                ),
                title: Text(convo.otherPartyName),
                subtitle: Text(
                  convo.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(convo.lastMessageTime),
                onTap: () => _navigateToChat(convo),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman daftar babysitter
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BabysitterListScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_comment_rounded),
        tooltip: 'Mulai Obrolan Baru',
      ),
    );
  }
}
