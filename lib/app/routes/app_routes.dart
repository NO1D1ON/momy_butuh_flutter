// File ini berisi nama-nama rute agar tidak ada salah ketik (typo).
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  // static const HOME = _Paths.HOME;
  static const HOME = _Paths.DASHBOARD;
  static const REGISTER = _Paths.REGISTER;
  static const BABYSITTER_DETAIL = _Paths.BABYSITTER_DETAIL;
  static const BOOKING = _Paths.BOOKING;
  static const CHAT = _Paths.CHAT;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  // static const HOME = '/home';
  static const DASHBOARD = '/dashboard';
  static const REGISTER = '/register';
  static const BABYSITTER_DETAIL = '/babysitter-detail';
  static const BOOKING = '/booking';
  static const CHAT = '/chat';
}
