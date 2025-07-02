import 'dart:convert';
import 'package:get/get.dart';
import 'package:momy_butuh_flutter/app/data/models/notification_model.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/echo_service.dart';
import 'package:momy_butuh_flutter/app/data/services/notification_service.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var notifications = <AppNotification>[].obs;

  // Dependensi yang di-inject melalui GetX
  final EchoService _echoService = Get.find<EchoService>();
  final AuthService _authService = Get.find<AuthService>();

  // Properti untuk menyimpan ID pengguna agar tidak perlu memanggil berulang kali
  String? _currentUserId;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    // Berhenti mendengarkan channel notifikasi saat controller ditutup
    if (_currentUserId != null) {
      _echoService.unsubscribe(channelName: 'notifications.$_currentUserId');
    }
    super.onClose();
  }

  /// Inisialisasi data dan listener
  Future<void> _initialize() async {
    fetchNotifications();
    await listenForRealtimeUpdates();
  }

  void fetchNotifications() async {
    try {
      isLoading(true);
      var result = await NotificationService.getNotifications();
      notifications.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat notifikasi: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  /// Menggunakan EchoService yang baru untuk mendengarkan notifikasi.
  Future<void> listenForRealtimeUpdates() async {
    // Pastikan koneksi sudah diinisialisasi
    await _echoService.init();

    // Ambil User ID sekali saja
    _currentUserId = await _authService.getUserId();
    if (_currentUserId == null) return;

    // Gunakan metode subscribe yang generik dari EchoService
    _echoService.subscribe(
      channelName: 'notifications.$_currentUserId',
      // Pastikan nama event ini sama persis dengan yang ada di backend Laravel
      // Biasanya tanpa titik di depan jika menggunakan Notifiable trait standar
      eventName: 'new.notification',
      onEventCallback: (decodedData) {
        // Callback ini menerima data yang sudah di-decode menjadi Map/List
        try {
          // Struktur data dari Laravel Notification biasanya { 'notification': {...} }
          if (decodedData is Map<String, dynamic> &&
              decodedData.containsKey('notification')) {
            final notificationData = decodedData['notification'];
            if (notificationData is Map<String, dynamic>) {
              final newNotification = AppNotification.fromJson(
                notificationData,
              );
              // Tambahkan notifikasi baru di paling atas daftar
              notifications.insert(0, newNotification);
            }
          }
        } catch (err) {
          print("Gagal memproses data notifikasi real-time: $err");
        }
      },
    );
  }

  void markNotificationAsRead(AppNotification notification) async {
    if (notification.isRead) return;

    final index = notifications.indexOf(notification);
    if (index != -1) {
      // Buat objek baru untuk memastikan UI reaktif
      notifications[index] = AppNotification(
        id: notification.id,
        type: notification.type,
        message: notification.message,
        createdAt: notification.createdAt,
        isRead: true,
      );
      // Refresh list agar Obx mendeteksi perubahan
      notifications.refresh();
    }

    await NotificationService.markAsRead(notification.id);
  }
}
