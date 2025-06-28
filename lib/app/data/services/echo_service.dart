import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';
import '../../utils/constants.dart';

class EchoService {
  // PERUBAHAN 1: Ubah dari 'late Echo echo' menjadi 'Echo?' agar bisa null
  Echo? echo;
  // --- TAMBAHKAN INI ---
  final _storage = const FlutterSecureStorage();

  Future<void> init() async {
    // --- UBAH BAGIAN INI ---
    final token = await _storage.read(key: 'auth_token');
    // --- BATAS PERUBAHAN ---

    if (token == null) {
      print("EchoService: Auth token not found. Cannot initialize.");
      return;
    }

    PusherClient pusherClient = PusherClient(
      AppConstants.reverbAppKey,
      PusherOptions(
        host: AppConstants.reverbHost,
        wsPort: AppConstants.reverbPort,
        wssPort: AppConstants.reverbPort,
        encrypted: false,
        auth: PusherAuth(
          '${AppConstants.baseUrl}/broadcasting/auth', // Gunakan serverUrl
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      ),
      enableLogging: true,
    );

    echo = Echo(broadcaster: EchoBroadcasterType.Pusher, client: pusherClient);
    print("Echo initialized successfully.");
  }

  void listenToConversation(
    int conversationId,
    Function(dynamic) onMessageReceived,
  ) {
    if (echo == null) return;

    echo!.private('conversation.$conversationId').listen(
      'new.message', // <-- UBAH INI agar cocok dengan nama alias di Laravel
      (e) {
        print("Event 'new.message' diterima: $e");
        if (e != null) {
          // Data pesan ada di dalam 'message' sesuai struktur event
          onMessageReceived(e['message']);
        }
      },
    );
  }

  void disconnect() {
    // PERUBAHAN 3: Tambahkan pengecekan null sebelum memutuskan koneksi
    if (echo != null) {
      echo!.disconnect();
      print("Echo disconnected.");
    }
  }
}
