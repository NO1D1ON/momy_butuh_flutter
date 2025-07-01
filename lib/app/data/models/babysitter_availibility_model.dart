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

  // --- PERUBAHAN 1: Tambahkan properti latitude dan longitude ---
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
    // --- PERUBAHAN 2: Tambahkan ke konstruktor ---
    this.latitude,
    this.longitude,
  });

  factory BabysitterAvailability.fromJson(Map<String, dynamic> json) {
    try {
      return BabysitterAvailability(
        id: json['id'] ?? 0,
        availableDate: json['available_date'] ?? '',
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        ratePerHour: json['rate_per_hour'] ?? 0,
        locationPreference: json['location_preference'] ?? 'Area sekitar',
        babysitter: json['babysitter'] != null
            ? Babysitter.fromJson(json['babysitter'])
            : Babysitter.empty(),
        name: json['name'] ?? 'Nama tidak tersedia',
        photoUrl: json['photo_url'],
        age: json['age'] ?? 0,
        rating: _parseDouble(json['rating']),
        // --- PERUBAHAN 3: Ambil dan parse latitude & longitude dari JSON ---
        latitude: _parseDouble(json['latitude']),
        longitude: _parseDouble(json['longitude']),
      );
    } catch (e) {
      print('Error parsing BabysitterAvailability: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Helper method untuk parsing double yang aman
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
