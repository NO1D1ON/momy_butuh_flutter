import 'package:momy_butuh_flutter/app/data/models/babysitter_model.dart';

class BabysitterAvailability {
  final int id;
  final String availableDate;
  final String startTime;
  final String endTime;
  final int ratePerHour;
  final String locationPreference;
  final Babysitter babysitter;
  final String? photoUrl;
  final int age;
  final double rating;
  final String name;
  final double? latitude;
  final double? longitude;

  BabysitterAvailability({
    required this.id,
    required this.availableDate,
    required this.startTime,
    required this.endTime,
    required this.ratePerHour,
    required this.locationPreference,
    required this.babysitter,
    required this.name,
    this.photoUrl,
    required this.age,
    required this.rating,
    this.latitude,
    this.longitude,
  });

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani berbagai format data dari API.
  factory BabysitterAvailability.fromJson(Map<String, dynamic> json) {
    try {
      return BabysitterAvailability(
        // Mengonversi semua field numerik dengan aman.
        id: int.tryParse(json['id'].toString()) ?? 0,
        ratePerHour: int.tryParse(json['rate_per_hour'].toString()) ?? 0,
        age: int.tryParse(json['age'].toString()) ?? 0,
        rating: double.tryParse(json['rating'].toString()) ?? 0.0,

        availableDate: json['available_date'] ?? '',
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        locationPreference: json['location_preference'] ?? 'Area sekitar',

        babysitter: json['babysitter'] != null
            ? Babysitter.fromJson(json['babysitter'])
            : Babysitter.empty(),

        name: json['name'] ?? 'Nama tidak tersedia',
        photoUrl: json['photo_url'],

        latitude: json['latitude'] != null
            ? double.tryParse(json['latitude'].toString())
            : null,
        longitude: json['longitude'] != null
            ? double.tryParse(json['longitude'].toString())
            : null,
      );
    } catch (e) {
      print('Error parsing BabysitterAvailability: $e');
      print('JSON data: $json');
      rethrow; // Tetap lemparkan error untuk debugging jika diperlukan
    }
  }
}
