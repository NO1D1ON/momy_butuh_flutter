class Booking {
  final int id;
  final String babysitterName;
  final String bookingDate;
  final String status;

  Booking({
    required this.id,
    required this.babysitterName,
    required this.bookingDate,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      // Pastikan membaca dari kunci 'babysitter_name'
      babysitterName: json['babysitter_name'] ?? 'N/A',
      bookingDate: json['booking_date'],
      status: json['status'],
    );
  }
}
