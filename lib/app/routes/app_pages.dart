// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/auth_babysitter/auth_babysitter_binding.dart';
import 'package:momy_butuh_flutter/app/modules/auth_babysitter/login_view_babysitter.dart';
import 'package:momy_butuh_flutter/app/modules/auth_babysitter/register_view_babysitter.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_dashboard/babysitter_dashboard_binding.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_dashboard/babysitter_dashboard_view.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_detail/bindings/babysitter_detail_binding.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_detail/views/babysitter_detail_view.dart';
import 'package:momy_butuh_flutter/app/modules/booking/bindings/booking_binding.dart';
import 'package:momy_butuh_flutter/app/modules/booking/views/booking_view.dart';
import 'package:momy_butuh_flutter/app/modules/chat/bindings/chat_binding.dart';
import 'package:momy_butuh_flutter/app/modules/chat/views/chat_view.dart';
import 'package:momy_butuh_flutter/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:momy_butuh_flutter/app/modules/dashboard/views/dashboard_view.dart';
import 'package:momy_butuh_flutter/app/modules/map_view/map_view_binding.dart';
import 'package:momy_butuh_flutter/app/modules/map_view/map_view_view.dart';
import 'package:momy_butuh_flutter/app/modules/role_selection/role_selection_view.dart';
import 'package:momy_butuh_flutter/app/modules/topup/topup_binding.dart';
import 'package:momy_butuh_flutter/app/modules/topup/topup_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.SPLASH, page: () => const SplashView()),
    GetPage(name: _Paths.ROLE_SELECTION, page: () => const RoleSelectionView()),

    // Rute Otentikasi Orang Tua
    GetPage(
      name: _Paths.LOGIN_PARENT,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_PARENT,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),

    // Rute Otentikasi Babysitter
    GetPage(
      name: _Paths.LOGIN_BABYSITTER,
      page: () => const LoginBabysitterView(),
      binding: AuthBabysitterBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_BABYSITTER,
      page: () => const RegisterBabysitterView(),
      binding: AuthBabysitterBinding(),
    ),

    // Rute Dashboard
    GetPage(
      name: _Paths.DASHBOARD_PARENT,
      page: () => const DashboardView(), // Dashboard untuk Orang Tua
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_BABYSITTER,
      page: () => const BabysitterDashboardView(), // Dashboard untuk Babysitter
      binding: BabysitterDashboardBinding(),
    ),

    // Rute Fitur Lainnya
    GetPage(
      name: _Paths.BABYSITTER_DETAIL,
      page: () => const BabysitterDetailView(),
      binding: BabysitterDetailBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.TOPUP,
      page: () => const TopupView(),
      binding: TopupBinding(),
    ),

    GetPage(
      name: _Paths.MAP_VIEW,
      page: () => const MapView(),
      binding: MapBinding(),
    ),
  ];
}
