// File: lib/app/data/models/review_model.dart

import 'package:momy_butuh_flutter/app/data/models/user_model.dart';

class Review {
  final int id;
  final double rating;
  final String comment;
  final UserModel? user;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    this.user,
  });

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani angka yang dikirim sebagai String.
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      // Mengonversi 'id' dengan aman, memberikan nilai default 0 jika null atau gagal.
      id: int.tryParse(json['id'].toString()) ?? 0,

      // Parsing untuk 'rating' sudah aman.
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,

      comment: json['comment'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  /// Mengubah objek Review menjadi Map, berguna untuk serialisasi.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'user': user?.toJson(), // Pastikan UserModel punya toJson juga
    };
  }
}
