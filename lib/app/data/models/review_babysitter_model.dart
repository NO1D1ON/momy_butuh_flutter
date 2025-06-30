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

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      comment: json['comment'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  // ✅ Tambahkan toJson untuk menghindari error
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'user': user?.toJson(), // Pastikan UserModel punya toJson juga
    };
  }
}
