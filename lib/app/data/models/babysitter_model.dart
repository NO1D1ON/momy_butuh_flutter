import 'package:momy_butuh_flutter/app/data/models/review_babysitter_model.dart';

class Babysitter {
  final int id;
  final String name;
  final String? photoUrl;
  final String bio;
  final int age;
  final String address;
  final int ratePerHour;
  final double rating;
  final int? experienceYears;
  final String? birthDate;
  final List<Review> reviews;

  final double? latitude;
  final double? longitude;

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
    this.birthDate,
    this.reviews = const [],
    this.latitude,
    this.longitude,
  });

  // Constructor kosong
  Babysitter.empty()
    : id = 0,
      name = 'Unknown',
      photoUrl = null,
      bio = 'Tidak ada bio.',
      age = 0,
      address = 'Lokasi tidak tersedia',
      ratePerHour = 0,
      rating = 0.0,
      experienceYears = null,
      birthDate = null,
      reviews = const [],
      latitude = null,
      longitude = null;

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani berbagai format data dari API.
  factory Babysitter.fromJson(Map<String, dynamic> json) {
    try {
      var reviewList = <Review>[];
      if (json['reviews'] != null && json['reviews'] is List) {
        reviewList = (json['reviews'] as List)
            .map((reviewJson) {
              try {
                return Review.fromJson(reviewJson);
              } catch (e) {
                print('Error parsing review: $e');
                return null;
              }
            })
            .where((review) => review != null)
            .cast<Review>()
            .toList();
      }

      return Babysitter(
        id: int.tryParse(json['id'].toString()) ?? 0,
        name: json['name']?.toString() ?? 'Nama tidak tersedia',
        photoUrl: json['photo_url']?.toString(),
        bio: json['bio']?.toString() ?? 'Tidak ada bio.',
        age: int.tryParse(json['age'].toString()) ?? 0,
        address: json['address']?.toString() ?? 'Lokasi tidak tersedia',
        ratePerHour: int.tryParse(json['rate_per_hour'].toString()) ?? 0,
        rating: double.tryParse(json['rating'].toString()) ?? 0.0,
        experienceYears: json['experience_years'] != null
            ? int.tryParse(json['experience_years'].toString())
            : null,
        birthDate: json['birth_date']?.toString(),
        reviews: reviewList,
        latitude: json['latitude'] != null
            ? double.tryParse(json['latitude'].toString())
            : null,
        longitude: json['longitude'] != null
            ? double.tryParse(json['longitude'].toString())
            : null,
      );
    } catch (e) {
      print('Error parsing Babysitter: $e');
      print('JSON data: $json');
      return Babysitter.empty();
    }
  }

  // Getter tambahan
  double? get lat => latitude;
  double? get lng => longitude;

  String get photoUrlWithFallback {
    return photoUrl ?? 'https://placehold.co/80x80/E0E0E0/white?text=User';
  }

  String get formattedRating {
    return rating > 0 ? rating.toStringAsFixed(1) : 'N/A';
  }

  bool get isValid {
    return id > 0 && name.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo_url': photoUrl,
      'bio': bio,
      'age': age,
      'address': address,
      'rate_per_hour': ratePerHour,
      'rating': rating,
      'experience_years': experienceYears,
      'birth_date': birthDate,
      'latitude': latitude,
      'longitude': longitude,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  Babysitter copyWith({
    int? id,
    String? name,
    String? photoUrl,
    String? bio,
    int? age,
    String? address,
    int? ratePerHour,
    double? rating,
    int? experienceYears,
    String? birthDate,
    List<Review>? reviews,
    double? latitude,
    double? longitude,
  }) {
    return Babysitter(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      address: address ?? this.address,
      ratePerHour: ratePerHour ?? this.ratePerHour,
      rating: rating ?? this.rating,
      experienceYears: experienceYears ?? this.experienceYears,
      birthDate: birthDate ?? this.birthDate,
      reviews: reviews ?? this.reviews,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'Babysitter(id: $id, name: $name, age: $age, rating: $rating, lat: $latitude, lng: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Babysitter && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
