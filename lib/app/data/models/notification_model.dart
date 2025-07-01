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

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'unknown',
      message: json['message'] ?? 'Tidak ada pesan.',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isRead: json['read_at'] != null,
    );
  }

  // Helper untuk mendapatkan ikon berdasarkan tipe notifikasi
  IconData get icon {
    switch (type) {
      case 'booking_accepted':
        return Icons.check_circle_outline;
      case 'booking_completed':
        return Icons.task_alt_outlined;
      case 'payment_success':
        return Icons.payment_outlined;
      case 'topup_success':
        return Icons.account_balance_wallet_outlined;
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
