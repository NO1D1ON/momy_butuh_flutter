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
  // Dependensi ini akan di-inject oleh ChatBinding
  final AuthService authService;
  final http.Client httpClient;

  // Properti yang didapat dari halaman sebelumnya
  late final Babysitter babysitter;
  late final int conversationId;

  // --- UI STATE MANAGEMENT (REAKTIF DENGAN .obs) ---
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final isOpponentTyping = false.obs;
  final messages = <ChatUIMessage>[].obs; // Daftar pesan yang reaktif

  // --- CONTROLLER & KONEKSI NON-REAKTIF ---
  final textController = TextEditingController();
  final scrollController = ScrollController();
  WebSocketChannel? _webSocketChannel;
  Timer? _typingTimer;
  int? _currentUserId;

  // Konstruktor untuk menerima dependensi
  ChatController({required this.authService, required this.httpClient});

  // --- SIKLUS HIDUP CONTROLLER (LIFECYCLE HOOKS) ---

  @override
  void onInit() {
    super.onInit();
    // Ambil data babysitter yang dikirim sebagai argumen
    _initializeBabysitter();
    _initializeChat();
  }

  @override
  void onClose() {
    // Selalu bersihkan sumber daya untuk mencegah memory leak
    _webSocketChannel?.sink.close();
    textController.dispose();
    scrollController.dispose();
    _typingTimer?.cancel();
    super.onClose();
  }

  // --- METODE UNTUK MENGINISIALISASI BABYSITTER ---

  void _initializeBabysitter() {
    try {
      final arguments = Get.arguments;

      if (arguments is Babysitter) {
        // Jika sudah berupa object Babysitter
        babysitter = arguments;
      } else if (arguments is Map<String, dynamic>) {
        // Jika berupa Map, parse menjadi Babysitter
        babysitter = Babysitter.fromJson(arguments);
      } else if (arguments is Map) {
        // Jika berupa Map dengan tipe generic, konversi dulu
        final Map<String, dynamic> babysitterMap = Map<String, dynamic>.from(
          arguments,
        );
        babysitter = Babysitter.fromJson(babysitterMap);
      } else {
        throw Exception('Format data babysitter tidak valid');
      }
    } catch (e) {
      errorMessage.value = 'Gagal memproses data babysitter: ${e.toString()}';
      // Set babysitter default atau handle error sesuai kebutuhan
      rethrow;
    }
  }

  // --- METODE LOGIKA UTAMA ---

  Future<void> _initializeChat() async {
    try {
      isLoading(true);
      errorMessage('');

      // 1. Dapatkan profil pengguna saat ini
      final profileResponse = await authService.getProfile();
      if (profileResponse['success'] != true)
        throw Exception('Gagal memuat profil.');
      _currentUserId = profileResponse['data']['id'];

      // 2. Inisiasi percakapan untuk mendapatkan ID
      final convoResponse = await _initiateConversation();
      conversationId = convoResponse['id'];

      // 3. Ambil riwayat pesan
      await _fetchMessageHistory();

      // 4. Hubungkan ke WebSocket
      _connectToWebSocket();
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
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
      body: jsonEncode({'babysitter_id': babysitter.id}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Tambahkan validasi untuk memastikan struktur response benar
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('id')) {
        return responseData;
      } else {
        throw Exception('Response format tidak valid');
      }
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

      // Validasi struktur response
      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('data')) {
        final data = responseBody['data'];

        if (data is List) {
          final history = data
              .map((msgJson) {
                // Tambahkan null safety
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

  void _connectToWebSocket() {
    // Implementasi koneksi WebSocket, otorisasi, dan listener
    // ... (Logika ini akan sama seperti di ChatScreen sebelumnya,
    //      namun sekarang memanipulasi state controller, bukan setState)
  }

  void sendMessage() async {
    if (textController.text.trim().isEmpty) return;

    final text = textController.text.trim();
    textController.clear();

    // UI Optimis: Langsung tambahkan pesan ke daftar
    messages.add(ChatUIMessage(text: text, isMe: true));
    _scrollToBottom();

    // Kirim ke backend
    try {
      final token = await authService.getToken();
      final response = await httpClient.post(
        Uri.parse('${AppConstants.baseUrl}/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'body': text, 'receiver_id': babysitter.id}),
      );

      // Validasi response
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal mengirim pesan. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle gagal kirim - bisa remove pesan dari UI atau show error
      print("Gagal mengirim pesan: $e");
      // Optional: Remove last message if failed
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
