import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../utils/constants.dart';

class EchoService {
  // Gunakan instance singleton dari paket baru
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  final _storage = const FlutterSecureStorage();
  bool _isConnected = false;

  /// Inisialisasi dan koneksi ke server Pusher/Reverb.
  Future<void> init() async {
    // Mencegah inisialisasi ganda jika sudah terkoneksi
    if (_isConnected) {
      print("Pusher channels already connected.");
      return;
    }

    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      print("EchoService: Auth token not found. Cannot initialize.");
      return;
    }

    try {
      // Inisialisasi koneksi dengan semua konfigurasi yang diperlukan
      await _pusher.init(
        apiKey: AppConstants.reverbAppKey,
        cluster:
            'ap1', // Ganti dengan cluster Anda jika berbeda, atau biarkan default
        // Callback ini akan menangani otentikasi untuk channel privat secara otomatis
        onAuthorizer: (channelName, socketId, options) async {
          final authUrl = Uri.parse(
            '${AppConstants.baseUrl.replaceFirst('/api', '')}/broadcasting/auth',
          );

          final response = await http.post(
            authUrl,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'socket_id': socketId,
              'channel_name': channelName,
            }),
          );

          if (response.statusCode == 200) {
            return jsonDecode(response.body);
          } else {
            print(
              "Pusher Auth Failed: ${response.statusCode} ${response.body}",
            );
            throw Exception("Failed to authorize pusher channel");
          }
        },
        onConnectionStateChange: (currentState, previousState) {
          print(
            "Pusher connection state changed from $previousState to $currentState",
          );
        },
        onError: (message, code, error) {
          print("Pusher error: $message, code: $code, error: $error");
        },
      );

      // Mulai koneksi ke server
      await _pusher.connect();
      _isConnected = true;
      print("Pusher connected successfully.");
    } catch (e) {
      print("Failed to initialize and connect Pusher: $e");
      _isConnected = false;
    }
  }

  /// Metode generik untuk berlangganan ke channel dan mendengarkan event tertentu.
  void subscribe({
    required String channelName,
    required String eventName,
    required Function(dynamic) onEventCallback,
  }) {
    if (!_isConnected) {
      print("Cannot subscribe, Pusher is not connected.");
      return;
    }
    // Hapus langganan lama jika ada untuk menghindari duplikasi listener
    _pusher.unsubscribe(channelName: channelName);

    // Subscribe ke channel
    _pusher.subscribe(
      channelName: channelName,
      onEvent: (event) {
        if (event.eventName == eventName) {
          print(
            "Event '$eventName' received on channel $channelName: ${event.data}",
          );
          try {
            // Data event biasanya berupa String JSON, perlu di-decode
            final data = jsonDecode(event.data);
            onEventCallback(data); // Kirim data yang sudah di-decode
          } catch (e) {
            print("Error decoding event data: $e");
          }
        }
      },
      onSubscriptionSucceeded: (data) {
        print("Successfully subscribed to channel: $channelName");
      },
      onSubscriptionError: (message, error) {
        print(
          "Subscription to channel $channelName failed: $message, error: $error",
        );
      },
    );
  }

  /// Berhenti berlangganan dari sebuah channel.
  void unsubscribe({required String channelName}) {
    if (!_isConnected) {
      return;
    }
    _pusher.unsubscribe(channelName: channelName);
    print("Unsubscribed from channel: $channelName");
  }

  /// Berlangganan ke channel percakapan (contoh penggunaan metode subscribe).
  void listenToConversation(
    int conversationId,
    Function(dynamic) onMessageReceived,
  ) {
    subscribe(
      channelName: 'private-conversation.$conversationId',
      eventName: 'new.message',
      onEventCallback: (data) {
        if (data != null && data['message'] != null) {
          onMessageReceived(data['message']);
        }
      },
    );
  }

  /// Memutuskan koneksi dari server Pusher/Reverb.
  void disconnect() {
    if (_isConnected) {
      _pusher.disconnect();
      _isConnected = false;
      print("Pusher disconnected.");
    }
  }
}
