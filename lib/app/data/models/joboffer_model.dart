// Model untuk data satu penawaran pekerjaan
class JobOffer {
  // Properti untuk menampilkan daftar penawaran (dari API GET /job-offers)
  final int id;
  final String title;
  final String locationAddress;
  final String parentName;

  // Properti untuk mengirim penawaran baru (ke API POST /job-offers)
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? jobDate;
  final String? startTime;
  final String? endTime;
  final int? offeredPrice;
  final String status;

  JobOffer({
    required this.id,
    required this.title,
    required this.locationAddress,
    required this.parentName,
    this.description,
    this.latitude,
    this.longitude,
    this.jobDate,
    this.startTime,
    this.endTime,
    this.offeredPrice,
    required this.status,
  });

  /**
   * Factory constructor untuk membuat instance JobOffer dari JSON
   * yang diterima dari API (saat menampilkan daftar atau detail).
   * Kode ini sudah diperbaiki untuk menangani berbagai format data dari API.
   */
  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      // Mengonversi 'id' dengan aman, baik itu String, int, atau null.
      id: int.tryParse(json['id'].toString()) ?? 0,

      title: json['title'] ?? 'Tanpa Judul',
      locationAddress: json['location_address'] ?? 'Lokasi tidak tersedia',

      // Ambil nama dari data relasi 'user' yang kita sertakan di API
      parentName: json['user']?['name'] ?? 'Nama Pemesan Disembunyikan',

      description: json['description'],

      // Mengonversi 'latitude' dan 'longitude' dengan aman.
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,

      jobDate: json['job_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],

      // Mengonversi 'offered_price' dengan aman.
      offeredPrice: json['offered_price'] != null
          ? int.tryParse(json['offered_price'].toString())
          : null,

      status: json['status'] ?? 'open',
    );
  }

  /**
   * Method untuk mengubah objek JobOffer menjadi Map<String, String>
   * yang siap untuk dikirim sebagai 'body' dalam permintaan HTTP POST.
   */
  Map<String, String> toJson() {
    return {
      'title': title,
      'description': description ?? '',
      'location_address': locationAddress,
      'latitude': latitude?.toString() ?? '0.0',
      'longitude': longitude?.toString() ?? '0.0',
      'job_date': jobDate ?? '',
      'start_time': startTime ?? '',
      'end_time': endTime ?? '',
      'offered_price': offeredPrice?.toString() ?? '0',
    };
  }
}
