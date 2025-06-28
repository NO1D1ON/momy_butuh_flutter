// File: lib/app/data/models/review_model.dart

// Model ini merepresentasikan data User sederhana yang terkait dengan sebuah review.
// Kita hanya butuh nama dari pemberi ulasan.
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
}
