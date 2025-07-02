// File: lib/app/data/models/notification_model.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppNotification {
  final int id;
  final String type;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani angka yang dikirim sebagai String.
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      // Mengonversi 'id' dengan aman, memberikan nilai default 0 jika null atau gagal.
      id: int.tryParse(json['id'].toString()) ?? 0,

      type: json['type'] ?? 'unknown',
      message:
          json['data']?['message'] ??
          'Tidak ada pesan.', // Mengambil dari nested 'data'
      // Parsing tanggal sudah cukup aman.
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),

      isRead: json['read_at'] != null,
    );
  }

  // Helper untuk mendapatkan ikon berdasarkan tipe notifikasi
  IconData get icon {
    switch (type) {
      case 'App\\Notifications\\BookingCompleted': // Sesuaikan dengan nama kelas Notifikasi di Laravel
        return Icons.task_alt_outlined;
      case 'App\\Notifications\\TopUpSuccess': // Sesuaikan dengan nama kelas Notifikasi di Laravel
        return Icons.account_balance_wallet_outlined;
      case 'App\\Notifications\\NewBookingRequest': // Sesuaikan dengan nama kelas Notifikasi di Laravel
        return Icons.calendar_today_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  // Helper untuk memformat waktu
  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 0) {
      return DateFormat('d MMM y', 'id_ID').format(createdAt);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}
