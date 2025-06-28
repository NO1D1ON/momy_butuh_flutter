import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_booking/babysitter_booking_view.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_home/babysitter_home_view.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_orders/view.dart';
import 'package:momy_butuh_flutter/app/modules/conversation_list/views/conversation_list_view.dart';
import 'package:momy_butuh_flutter/app/modules/profil/views/profile_login.dart';

class BabysitterDashboardController extends GetxController {
  // State untuk melacak tab yang sedang aktif
  var tabIndex = 0.obs;

  // Daftar halaman yang akan ditampilkan sesuai dengan tab
  // Menggunakan IndexedStack nanti akan menjaga state setiap halaman
  final pages = [
    const BabysitterHomeView(),
    const BabysitterBookingsView(),
    const ConversationListView(),
    const ProfileView(),
  ];

  // Fungsi untuk mengubah tab yang aktif
  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
