// Model untuk data booking
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

  // Factory constructor untuk membuat instance Booking dari JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      // Kita ambil nama babysitter dari data relasi yang kita sertakan di API
      babysitterName: json['babysitter']['name'] ?? 'N/A',
      bookingDate: json['booking_date'],
      status: json['status'],
    );
  }
}
