import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/booking_history/views/booking_history_view.dart';
import 'package:momy_butuh_flutter/app/modules/conversation_list/views/conversation_list_view.dart';
import 'package:momy_butuh_flutter/app/modules/favorite/views/favorite_view.dart';
import 'package:momy_butuh_flutter/app/modules/profil/views/profile_login.dart';
import '../../home/views/home_view.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  // Menyimpan indeks tab yang sedang aktif
  var tabIndex = 0.obs;

  // Daftar halaman yang akan ditampilkan sesuai tab
  final List<Widget> pages = [
    const HomeView(),
    const FavoriteView(),
    const BookingHistoryView(),
    const ConversationListView(),
    const ProfileView(), // Placeholder
  ];

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
