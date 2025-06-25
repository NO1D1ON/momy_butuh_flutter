import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';

class EchoService {
  // PERUBAHAN 1: Ubah dari 'late Echo echo' menjadi 'Echo?' agar bisa null
  Echo? echo;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    PusherClient pusherClient = PusherClient(
      AppConstants.reverbAppKey,
      PusherOptions(
        host: AppConstants.reverbHost,
        wsPort: AppConstants.reverbPort,
        wssPort: AppConstants.reverbPort,
        encrypted: false,
        auth: PusherAuth(
          '${AppConstants.baseUrl}/broadcasting/auth',
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      ),
      enableLogging: true,
    );

    // Inisialisasi seperti biasa
    echo = Echo(broadcaster: EchoBroadcasterType.Pusher, client: pusherClient);
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
