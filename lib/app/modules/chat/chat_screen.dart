import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:momy_butuh_flutter/app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Model untuk data pesan
class ChatMessage {
  final String text;
  final int senderId; // Gunakan ID untuk perbandingan yang lebih pasti
  final bool isMe;

  ChatMessage({required this.text, required this.senderId, required this.isMe});
}

class ChatScreen extends StatefulWidget {
  // Data yang dibutuhkan oleh halaman ini
  final int conversationId;
  final String otherPartyName;
  final int currentUserId; // ID pengguna yang sedang login

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.otherPartyName,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final http.Client _httpClient =
      http.Client(); // Gunakan satu instance http client

  WebSocketChannel? _channel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat riwayat pesan dan menghubungkan WebSocket
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _fetchMessageHistory();
    // if (mounted) {
    //   _connectToWebSocket();
    // }
  }

  // Mengambil riwayat pesan dari server
  Future<void> _fetchMessageHistory() async {
    // ... Logika untuk GET /api/conversations/{id}/messages
    // Anda bisa memindahkan logika dari ChatController lama ke sini
    // Untuk sekarang, kita biarkan kosong agar fokus pada real-time
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  // Menghubungkan ke server WebSocket (Reverb)
  // void _connectToWebSocket() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');
  //   if (token == null) return;

  //   try {
  //     // 1. Otorisasi ke channel privat
  //     final authResponse = await _httpClient.post(
  //       Uri.parse(
  //         '${AppConstants.baseUrl.replaceFirst('/api', '')}/broadcasting/auth',
  //       ),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'channel_name': 'private-conversation.${widget.conversationId}',
  //       }),
  //     );

  //     if (authResponse.statusCode != 200) {
  //       throw Exception('Gagal otorisasi broadcast: ${authResponse.body}');
  //     }
  //     final authData = jsonDecode(authResponse.body);

  //     // 2. Hubungkan ke WebSocket
  //     final reverbAppKey = AppConstants.reverbAppKey;
  //     final wsUrl =
  //         'ws://${AppConstants.reverbHost}:${AppConstants.reverbPort}/app/$reverbAppKey';
  //     _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

  //     // 3. Dengarkan stream
  //     _channel!.stream.listen((data) {
  //       final decoded = jsonDecode(data);

  //       // Setelah koneksi terbentuk, subscribe ke channel privat
  //       if (decoded['event'] == 'pusher:connection_established') {
  //         _channel!.sink.add(
  //           jsonEncode({
  //             'event': 'pusher:subscribe',
  //             'data': {
  //               'auth': authData['auth'],
  //               'channel': 'private-conversation.${widget.conversationId}',
  //             },
  //           }),
  //         );
  //       }
  //       // Jika ada event 'new.message' yang masuk
  //       else if (decoded['event'] == 'new.message' &&
  //           decoded['channel'] ==
  //               'private-conversation.${widget.conversationId}') {
  //         final messageData = decoded['data']['message'];
  //         final newMessage = ChatMessage(
  //           text: messageData['body'],
  //           senderId: messageData['sender_id'],
  //           isMe: messageData['sender_id'] == widget.currentUserId,
  //         );
  //         if (mounted) {
  //           setState(
  //             () => _messages.insert(0, newMessage),
  //           ); // Tambah pesan baru di atas
  //           _scrollToBottom();
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print('Error menghubungkan ke WebSocket: $e');
  //   }
  // }

  // Mengirim pesan ke server
  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final messageText = _controller.text;
    _controller.clear();

    // Optimistic UI: Langsung tampilkan pesan di layar
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: messageText,
          senderId: widget.currentUserId,
          isMe: true,
        ),
      );
    });
    _scrollToBottom();

    // Kirim pesan ke API
    // (Pindahkan logika dari MessageService ke sini)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    try {
      await _httpClient.post(
        Uri.parse('${AppConstants.baseUrl}/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'body': messageText,
          // Anda perlu mengirim conversationId atau babysitterId ke API
          'conversation_id': widget.conversationId,
        }),
      );
    } catch (e) {
      // Jika gagal, tampilkan pesan error dan hapus pesan dari UI
      print("Gagal mengirim pesan: $e");
      if (mounted) {
        setState(() => _messages.removeAt(0));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim pesan. Coba lagi.')),
        );
      }
    }
  }

  // Fungsi untuk scroll otomatis ke bawah
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _controller.dispose();
    _scrollController.dispose();
    _httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI LENGKAP UNTUK CHAT SCREEN
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherPartyName)),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true, // Mulai dari bawah
                    padding: const EdgeInsets.all(12.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: msg.isMe
                                ? Theme.of(context).primaryColorLight
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(msg.text),
                        ),
                      );
                    },
                  ),
          ),
          // Input field untuk mengirim pesan
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.grey.withOpacity(0.1)),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ketik pesan...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
