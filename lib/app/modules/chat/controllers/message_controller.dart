import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

// Sesuaikan path impor dengan struktur proyek Anda
import '../../../data/models/babysitter_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../utils/constants.dart';

// Model sederhana untuk pesan di UI
class ChatUIMessage {
  final String text;
  final bool isMe;
  bool isRead;
  ChatUIMessage({required this.text, required this.isMe, this.isRead = false});
}

class ChatController extends GetxController {
  // --- DEKLARASI DEPENDENSI & PROPERTI ---
  final AuthService authService;
  final http.Client httpClient;

  // Properti ini akan diisi saat onInit, bisa null di awal
  Babysitter? babysitter;
  late final String otherPartyName;
  late final int otherPartyId;
  late int conversationId;

  // --- UI STATE MANAGEMENT (REAKTIF DENGAN .obs) ---
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final isOpponentTyping = false.obs;
  final messages = <ChatUIMessage>[].obs;

  // --- CONTROLLER & KONEKSI NON-REAKTIF ---
  final textController = TextEditingController();
  final scrollController = ScrollController();
  WebSocketChannel? _webSocketChannel;
  Timer? _typingTimer;
  int? _currentUserId;

  // Konstruktor untuk menerima dependensi
  ChatController({required this.authService, required this.httpClient});

  // --- SIKLUS HIDUP CONTROLLER ---

  @override
  void onInit() {
    super.onInit();
    // Panggil metode inisialisasi utama
    _initialize();
  }

  @override
  void onClose() {
    _webSocketChannel?.sink.close();
    textController.dispose();
    scrollController.dispose();
    _typingTimer?.cancel();
    super.onClose();
  }

  // --- METODE LOGIKA UTAMA ---

  Future<void> _initialize() async {
    try {
      isLoading(true);
      errorMessage('');

      final arguments = Get.arguments;

      // Langkah 1: Dapatkan profil pengguna saat ini
      final profileResponse = await authService.getProfile();
      if (profileResponse['success'] != true)
        throw Exception('Gagal memuat profil.');
      _currentUserId = profileResponse['data']['id'];

      // Langkah 2: Tentukan alur berdasarkan tipe argumen
      if (arguments is Babysitter) {
        // --- SKENARIO 1: Memulai chat BARU dari halaman profil/daftar Babysitter ---
        babysitter = arguments; // Tetap assign ke property kelas
        // PERBAIKAN: Gunakan variabel 'arguments' yang sudah pasti non-null
        // untuk menghindari error null safety.
        otherPartyId = arguments.id;
        otherPartyName = arguments.name;

        // Panggil API untuk mendapatkan atau membuat ID percakapan
        final convoData = await _initiateConversation();
        conversationId = convoData['id'];

        // Muat riwayat pesan (kemungkinan akan kosong untuk chat baru)
        await _fetchMessageHistory();
      } else if (arguments is Map<String, dynamic>) {
        // --- SKENARIO 2: Membuka chat yang SUDAH ADA dari ConversationList ---
        conversationId = arguments['conversation_id'];
        otherPartyId = arguments['other_party_id'];
        otherPartyName = arguments['other_party_name'];

        // Langsung muat riwayat pesan, JANGAN panggil _initiateConversation
        await _fetchMessageHistory();
      } else {
        throw Exception('Argumen untuk halaman chat tidak valid.');
      }

      // Langkah 3: Hubungkan ke WebSocket setelah semua data siap
      // _connectToWebSocket();
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      print("Error di ChatController: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> _initiateConversation() async {
    final token = await authService.getToken();
    final response = await httpClient.post(
      Uri.parse('${AppConstants.baseUrl}/conversations/initiate'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'babysitter_id': otherPartyId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception(
      'Gagal memulai sesi percakapan. Status: ${response.statusCode}',
    );
  }

  Future<void> _fetchMessageHistory() async {
    final token = await authService.getToken();
    final response = await httpClient.get(
      Uri.parse(
        '${AppConstants.baseUrl}/conversations/$conversationId/messages',
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('data')) {
        final data = responseBody['data'];

        if (data is List) {
          final history = data
              .map((msgJson) {
                if (msgJson is Map<String, dynamic>) {
                  return ChatUIMessage(
                    text: msgJson['body']?.toString() ?? '',
                    isMe: msgJson['sender_id'] == _currentUserId,
                    isRead: msgJson['read_at'] != null,
                  );
                }
                return null;
              })
              .where((msg) => msg != null)
              .cast<ChatUIMessage>()
              .toList();

          messages.assignAll(history.reversed);
        } else {
          throw Exception('Data pesan tidak dalam format yang benar');
        }
      } else {
        throw Exception('Response tidak mengandung data pesan');
      }
    } else {
      throw Exception(
        'Gagal memuat riwayat pesan. Status: ${response.statusCode}',
      );
    }
  }

  // void _connectToWebSocket() {
  //   // Implementasi koneksi WebSocket, otorisasi, dan listener
  // }

  void sendMessage() async {
    if (textController.text.trim().isEmpty) return;

    final text = textController.text.trim();
    textController.clear();

    messages.add(ChatUIMessage(text: text, isMe: true));
    _scrollToBottom();

    try {
      final token = await authService.getToken();
      // PERBAIKAN: Gunakan 'otherPartyId' yang sudah pasti ada, bukan 'babysitter.id'
      final response = await httpClient.post(
        Uri.parse('${AppConstants.baseUrl}/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'body': text, 'receiver_id': otherPartyId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal mengirim pesan. Status: ${response.statusCode}');
      }
    } catch (e) {
      print("Gagal mengirim pesan: $e");
      if (messages.isNotEmpty &&
          messages.last.isMe &&
          messages.last.text == text) {
        messages.removeLast();
      }
      errorMessage.value = 'Gagal mengirim pesan';
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
}
