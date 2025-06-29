import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Import paket http
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/message_service.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_booking/babysitter_booking_controller.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_dashboard/babysitter_dashboard_controller.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_home/babysitter_home_controller.dart';
import 'package:momy_butuh_flutter/app/modules/conversation_list/controllers/conversation_list_controller.dart';
import 'package:momy_butuh_flutter/app/modules/profil/controllers/profile_controller.dart';
// Import service

class BabysitterDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // --- PERBAIKAN UTAMA DI SINI ---

    // Langkah A: Daftarkan service dan client yang akan digunakan bersama
    // Kita gunakan fenix: true agar instance ini tidak pernah dihapus oleh GetX
    // selama aplikasi berjalan, sehingga bisa dipakai ulang di halaman lain.
    Get.lazyPut<http.Client>(() => http.Client(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    // Langkah B: Daftarkan MessageService dan suntikkan dependensinya
    Get.lazyPut<MessageService>(
      () => MessageService(
        authService:
            Get.find<
              AuthService
            >(), // Ambil instance AuthService yang sudah ada
        httpClient:
            Get.find<
              http.Client
            >(), // Ambil instance http.Client yang sudah ada
      ),
      fenix: true,
    );

    // Langkah C: Daftarkan semua controller untuk setiap tab
    Get.lazyPut<BabysitterDashboardController>(
      () => BabysitterDashboardController(),
    );
    Get.lazyPut<BabysitterHomeController>(() => BabysitterHomeController());
    Get.lazyPut<BabysitterBookingsController>(
      () => BabysitterBookingsController(),
    );
    Get.lazyPut<ProfileController>(() => ProfileController());

    // Langkah D: Daftarkan ConversationListController dengan dependensi yang sudah siap
    Get.lazyPut<ConversationListController>(
      () => ConversationListController(
        messageService:
            Get.find<MessageService>(), // Ambil instance MessageService
        authService: Get.find<AuthService>(), // Ambil instance AuthService
        httpClient: Get.find<http.Client>(), // Ambil instance http.Client
      ),
    );
  }
}
