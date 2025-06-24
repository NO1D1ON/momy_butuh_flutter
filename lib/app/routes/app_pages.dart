// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_detail/bindings/babysitter_detail_binding.dart';
import 'package:momy_butuh_flutter/app/modules/babysitter_detail/views/babysitter_detail_view.dart';
import 'package:momy_butuh_flutter/app/modules/booking/bindings/booking_binding.dart';
import 'package:momy_butuh_flutter/app/modules/booking/views/booking_view.dart';
import 'package:momy_butuh_flutter/app/modules/chat/bindings/chat_binding.dart';
import 'package:momy_butuh_flutter/app/modules/chat/views/chat_view.dart';
import 'package:momy_butuh_flutter/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:momy_butuh_flutter/app/modules/dashboard/views/dashboard_view.dart';
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
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(), // Gunakan binding
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(), // Gunakan binding yang sama
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),

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
  ];
}
