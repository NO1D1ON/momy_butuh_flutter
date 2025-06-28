import 'package:momy_butuh_flutter/app/data/models/review_babysitter_model.dart';

// Model ini SEKARANG cocok dengan BabysitterResource.php di Laravel
class Babysitter {
  final int id;
  final String name;
  final String? photoUrl; // Laravel tidak mengirimkan ini, kita buat nullable
  final String bio; // DIGANTI: dari 'description' menjadi 'bio'
  final int age;
  final String address;
  final int ratePerHour; // DIGANTI: dari 'pricePerHour' menjadi 'ratePerHour'
  final double rating; // DIGANTI: dari 'averageRating' menjadi 'rating'
  final int? experienceYears;
  final List<Review> reviews;

  Babysitter({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.bio,
    required this.age,
    required this.address,
    required this.ratePerHour,
    required this.rating,
    this.experienceYears,
    this.reviews = const [],
  });

  // Factory constructor yang sudah disesuaikan dengan response API
  factory Babysitter.fromJson(Map<String, dynamic> json) {
    var reviewList = <Review>[];
    if (json['reviews'] != null && json['reviews'] is List) {
      reviewList = (json['reviews'] as List)
          .map((i) => Review.fromJson(i))
          .toList();
    }

    return Babysitter(
      id: json['id'] ?? -1,
      name: json['name'] ?? 'Nama tidak tersedia',
      photoUrl:
          json['photo_url'], // Laravel Resource belum ada, jadi ini akan null
      bio: json['bio'] ?? 'Tidak ada bio.', // DIPERBARUI
      age: json['age'] ?? 0,
      address: json['address'] ?? 'Lokasi tidak tersedia', // DIPERBARUI
      ratePerHour: json['rate_per_hour'] ?? 0, // DIPERBARUI
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0, // DIPERBARUI
      experienceYears: json['experience_years'] as int?,
      reviews: reviewList,
    );
  }
}
