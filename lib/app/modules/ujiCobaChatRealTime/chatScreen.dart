import 'dart:async'; // Impor untuk Timer
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart'; // Sesuaikan path jika perlu

// Model untuk data pesan
class ChatMessage {
  final String text;
  final String senderName;
  final bool isMe;
  bool isRead;

  ChatMessage({
    required this.text,
    required this.senderName,
    required this.isMe,
    this.isRead = false,
  });
}

class ChatScreen extends StatefulWidget {
  final int conversationId;
  final String otherPartyName;
  final int otherPartyId;
  final AuthService authService;
  // PERBAIKAN: Menerima http.Client sebagai parameter.
  final http.Client httpClient;

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.otherPartyName,
    required this.otherPartyId,
    required this.authService,
    // PERBAIKAN: Parameter ini sekarang wajib.
    required this.httpClient,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  WebSocketChannel? _channel;
  bool _isLoading = true;
  int? _currentUserId;
  Timer? _typingTimer;
  bool _isOpponentTyping = false;

  @override
  void initState() {
    super.initState();
    // Panggil _initializeChat yang akan menggunakan widget.httpClient
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _fetchProfileAndHistory();
    if (mounted) {
      _connectToWebSocket();
    }
  }

  Future<void> _fetchProfileAndHistory() async {
    try {
      final profileResponse = await widget.authService.getProfile();
      if (profileResponse['success'] != true || !mounted) return;

      _currentUserId = profileResponse['data']['id'];

      final token = await widget.authService.getToken();
      // PERBAIKAN: Menggunakan widget.httpClient.get
      final response = await widget.httpClient.get(
        Uri.parse(
          '${AppConstants.baseUrl}/conversations/${widget.conversationId}/messages',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final paginatedData = json.decode(response.body);
        final List<dynamic> messageList = paginatedData['data'];

        final history = messageList.map((msgJson) {
          return ChatMessage(
            text: msgJson['body'],
            senderName: msgJson['sender']['name'],
            isMe: msgJson['sender_id'] == _currentUserId,
          );
        }).toList();

        if (mounted) {
          setState(() {
            _messages.addAll(history.reversed);
            _isLoading = false;
          });
          _scrollToBottom();
        }
      } else {
        throw Exception('Gagal memuat riwayat pesan');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  void _connectToWebSocket() async {
    if (_currentUserId == null) return;

    final token = await widget.authService.getToken();
    if (token == null) return;

    try {
      // PERBAIKAN: Menggunakan widget.httpClient.post
      final authResponse = await widget.httpClient.post(
        Uri.parse(
          '${AppConstants.baseUrl.replaceFirst('/api', '')}/broadcasting/auth',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'channel_name': 'private-conversation.${widget.conversationId}',
        }),
      );

      if (authResponse.statusCode != 200) {
        throw Exception('Gagal otorisasi broadcast: ${authResponse.body}');
      }

      final reverbAppKey = 'your_reverb_app_key'; // Ganti dengan key Anda
      final wsUrl =
          'ws://${AppConstants.baseUrl.split('//')[1].split('/api')[0]}/app/$reverbAppKey?protocol=7&client=js&version=8.4.0-rc2&flash=false';

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _channel!.stream.listen(
        (data) {
          final decoded = jsonDecode(data);

          if (decoded['event'] == 'pusher:connection_established') {
            final authData = jsonDecode(authResponse.body);
            _channel!.sink.add(
              jsonEncode({
                'event': 'pusher:subscribe',
                'data': {
                  'auth': authData['auth'],
                  'channel': 'private-conversation.${widget.conversationId}',
                },
              }),
            );
          } else if (decoded['event'] == 'new.message' &&
              decoded['channel'] ==
                  'private-conversation.${widget.conversationId}') {
            final messageData = jsonDecode(decoded['data'])['message'];
            final newMessage = ChatMessage(
              text: messageData['body'],
              senderName: messageData['sender']['name'],
              isMe: messageData['sender']['id'] == _currentUserId,
            );
            if (mounted) {
              setState(() => _messages.add(newMessage));
              _scrollToBottom();
            }
          } else if (decoded['event'] == 'user.typing' &&
              decoded['channel'] ==
                  'presence-conversation.${widget.conversationId}') {
            final typingUser = decoded['data']['user'];
            if (typingUser['id'] != _currentUserId) {
              if (mounted) {
                setState(() => _isOpponentTyping = true);
                _typingTimer?.cancel();
                _typingTimer = Timer(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _isOpponentTyping = false);
                });
              }
            }
          }
        },
        onError: (error) => print('WebSocket Error: $error'),
        onDone: () => print('WebSocket Channel Closed'),
      );
    } catch (e) {
      print('Error menghubungkan ke WebSocket: $e');
    }
  }

  void _handleTyping() {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 500), () async {
      final token = await widget.authService.getToken();
      try {
        // PERBAIKAN: Menggunakan widget.httpClient.post
        await widget.httpClient.post(
          Uri.parse(
            '${AppConstants.baseUrl}/conversations/${widget.conversationId}/typing',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      } catch (e) {
        // Abaikan error untuk fitur ini agar tidak mengganggu user
      }
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty || _currentUserId == null) return;

    final messageText = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add(
        ChatMessage(text: messageText, senderName: 'Saya', isMe: true),
      );
    });
    _scrollToBottom();

    final token = await widget.authService.getToken();
    try {
      // PERBAIKAN: Menggunakan widget.httpClient.post
      await widget.httpClient.post(
        Uri.parse('${AppConstants.baseUrl}/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'body': messageText,
          'babysitter_id': widget.otherPartyId,
        }),
      );
    } catch (e) {
      print("Gagal mengirim pesan: $e");
      if (mounted) {
        setState(() {
          _messages.removeLast();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengirim pesan. Silakan coba lagi.'),
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _channel?.sink.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.otherPartyName),
            if (_isOpponentTyping)
              const Text(
                'sedang mengetik...',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
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
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isMe ? Colors.black87 : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 2,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: (text) => _handleTyping(),
                decoration: const InputDecoration(
                  hintText: 'Ketik pesan...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
