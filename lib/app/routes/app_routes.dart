part of 'app_pages.dart';

// Kelas ini berisi nama-nama rute yang akan kita gunakan di seluruh aplikasi
// untuk mencegah kesalahan ketik (typo).
abstract class Routes {
  Routes._();

  // Rute Awal
  static const SPLASH = _Paths.SPLASH;
  static const ROLE_SELECTION = _Paths.ROLE_SELECTION;

  // Rute Otentikasi
  static const LOGIN_PARENT = _Paths.LOGIN_PARENT;
  static const REGISTER_PARENT = _Paths.REGISTER_PARENT;
  static const LOGIN_BABYSITTER = _Paths.LOGIN_BABYSITTER;
  static const REGISTER_BABYSITTER = _Paths.REGISTER_BABYSITTER;

  // Rute Setelah Login (Dashboard Utama untuk setiap peran)
  static const DASHBOARD_PARENT = _Paths.DASHBOARD_PARENT;
  static const DASHBOARD_BABYSITTER = _Paths.DASHBOARD_BABYSITTER;

  // Alias untuk kemudahan, HOME untuk Orang Tua
  static const HOME = _Paths.DASHBOARD_PARENT;

  // Rute Detail & Fitur
  static const BABYSITTER_DETAIL = _Paths.BABYSITTER_DETAIL;
  static const BOOKING = _Paths.BOOKING;
  static const CHAT = _Paths.CHAT;
  static const TOPUP = _Paths.TOPUP;

  static const MAP_VIEW = _Paths.MAP_VIEW;
  static const JOB_OFFER_DETAIL = _Paths.JOB_OFFER_DETAIL;

  static const CREATE_JOB_OFFER = _Paths.CREATE_JOB_OFFER;
  static const SELECT_LOCATION = _Paths.SELECT_LOCATION;

  static const TRANSACTION_HISTORY = _Paths.TRANSACTION_HISTORY;
  static const BABYSITTER_SEARCH = _Paths.BABYSITTER_SEARCH;
}

// Kelas ini mendefinisikan path URL sebenarnya untuk setiap rute.
abstract class _Paths {
  _Paths._();

  // Rute Awal
  static const SPLASH = '/splash';
  static const ROLE_SELECTION = '/role-selection';

  // Rute Otentikasi
  static const LOGIN_PARENT = '/login-parent';
  static const REGISTER_PARENT = '/register-parent';
  static const LOGIN_BABYSITTER = '/login-babysitter';
  static const REGISTER_BABYSITTER = '/register-babysitter';

  // Rute Dashboard
  static const DASHBOARD_PARENT = '/dashboard-parent';
  static const DASHBOARD_BABYSITTER = '/dashboard-babysitter';

  // Rute Detail & Fitur
  static const BABYSITTER_DETAIL = '/babysitter-detail';
  static const BOOKING = '/booking';
  static const CHAT = '/chat';
  static const TOPUP = '/topup';

  static const MAP_VIEW = '/map-view';
  static const JOB_OFFER_DETAIL = '/job-offer-detail';
  static const CREATE_JOB_OFFER = '/create-job-offer';

  static const SELECT_LOCATION = '/select-location';
  static const TRANSACTION_HISTORY = '/transaction-history';
  static const BABYSITTER_SEARCH = '/babysitter-search';
}
