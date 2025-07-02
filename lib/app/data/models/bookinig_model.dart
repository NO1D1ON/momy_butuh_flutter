import 'package:momy_butuh_flutter/app/data/models/review_babysitter_model.dart';

class Booking {
  final int id;
  final String babysitterName;
  final String bookingDate;
  final String status;
  final String? parentName;
  final DateTime jobDate;
  final String? parentAddress;
  final int parentId;
  final String? startTime;
  final String? endTime;
  final Review? review;

  bool get hasReview => review != null;

  Booking({
    required this.id,
    required this.babysitterName,
    required this.bookingDate,
    required this.status,
    required this.jobDate,
    this.parentName,
    this.parentAddress,
    required this.parentId,
    this.startTime,
    this.endTime,
    this.review,
  });

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani berbagai format data dari API.
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      // Mengonversi 'id' dan 'parentId' dengan aman.
      id: int.tryParse(json['id'].toString()) ?? 0,
      parentId: int.tryParse(json['user_id'].toString()) ?? 0,

      babysitterName: json['babysitter_name'] ?? 'N/A',
      bookingDate: json['booking_date'] ?? '',
      status: json['status'] ?? 'unknown',

      // Mengambil data dari nested object 'user' dengan aman.
      parentName: json['user']?['name'] ?? 'Orang Tua',
      parentAddress: json['user']?['address'] ?? 'Alamat tidak ada',

      // Mengonversi tanggal dengan aman.
      jobDate: json['booking_date'] != null
          ? DateTime.tryParse(json['booking_date']) ?? DateTime.now()
          : DateTime.now(),

      startTime: json['start_time'],
      endTime: json['end_time'],

      // Parsing review sudah aman.
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }
}
