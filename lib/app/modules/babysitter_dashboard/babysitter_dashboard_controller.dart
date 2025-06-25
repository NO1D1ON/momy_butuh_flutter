import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_booking/babysitter_booking_view.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_home/babysitter_home_view.dart';
import 'package:momy_butuh_flutter/app/modules/conversation_list/views/conversation_list_view.dart';
import 'package:momy_butuh_flutter/app/modules/profil/views/profile_login.dart';
// Import semua view yang akan kita buat
// import '../../babysitter_home/views/babysitter_home_view.dart';
// import '../../babysitter_bookings/views/babysitter_bookings_view.dart';
// import '../../conversation_list/views/conversation_list_view.dart';
// import '../../profile/views/profile_view.dart';

class BabysitterDashboardController extends GetxController {
  var tabIndex = 0.obs;

  // Halaman untuk setiap tab
  final pages = [
    const BabysitterHomeView(),
    const BabysitterBookingsView(),
    const ConversationListView(),
    const ProfileView(),
  ];

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
