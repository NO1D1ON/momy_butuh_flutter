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
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      // Pastikan membaca dari kunci 'babysitter_name'
      babysitterName: json['babysitter_name'] ?? 'N/A',
      bookingDate: json['booking_date'],
      status: json['status'],
      parentName: json['user'] != null ? json['user']['name'] : 'Orang Tua',
      jobDate: DateTime.parse(json['booking_date']),
      parentId: json['user_id'],
      parentAddress: json['user'] != null
          ? json['user']['address']
          : 'Alamat tidak ada',
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
