import 'dart:convert'; // PERBAIKAN: Import dart:convert untuk json.decode
import 'package:get/get.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:momy_butuh_flutter/app/data/models/notification_model.dart';
import 'package:momy_butuh_flutter/app/data/services/auth_service.dart';
import 'package:momy_butuh_flutter/app/data/services/echo_service.dart';
import 'package:momy_butuh_flutter/app/data/services/notification_service.dart';
import 'package:pusher_client/pusher_client.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var notifications = <AppNotification>[].obs;

  final EchoService _echoService = Get.find<EchoService>();
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    listenForRealtimeUpdates();
  }

  @override
  void onClose() async {
    // PERBAIKAN: Jadikan onClose async
    super.onClose();
    // PERBAIKAN: Gunakan metode getUserId() yang asynchronous dan aman dari null
    final userId = await _authService.getUserId();
    if (userId != null) {
      _echoService.echo?.leave('notifications.$userId');
    }
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

  void listenForRealtimeUpdates() async {
    // PERBAIKAN: Panggil metode getUserId() yang sudah benar
    final userId = await _authService.getUserId();
    if (userId == null) return;

    _echoService.echo?.private('notifications.$userId').listen(
      '.new.notification', // Nama event dari backend
      (e) {
        if (e is PusherEvent) {
          // PERBAIKAN: Penanganan data dari PusherEvent yang lebih aman
          final eventDataString = e.data;
          if (eventDataString != null) {
            try {
              // PusherEvent.data adalah String, jadi perlu di-decode
              final decodedData = json.decode(eventDataString);

              // Pastikan data yang di-decode adalah Map dan memiliki key 'notification'
              if (decodedData is Map<String, dynamic> &&
                  decodedData.containsKey('notification')) {
                final notificationData = decodedData['notification'];
                // Pastikan notificationData juga adalah Map sebelum di-parse
                if (notificationData is Map<String, dynamic>) {
                  final newNotification = AppNotification.fromJson(
                    notificationData,
                  );
                  notifications.insert(0, newNotification);
                }
              }
            } catch (err) {
              print("Gagal parsing notifikasi real-time: $err");
              print("Data yang diterima: $eventDataString");
            }
          }
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
