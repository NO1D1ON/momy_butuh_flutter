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
  });

  /**
   * Factory constructor untuk membuat instance JobOffer dari JSON
   * yang diterima dari API (saat menampilkan daftar atau detail).
   */
  factory JobOffer.fromJson(Map<String, dynamic> json) {
    return JobOffer(
      id: json['id'],
      title: json['title'] ?? 'Tanpa Judul',
      locationAddress: json['location_address'] ?? 'Lokasi tidak tersedia',
      // Ambil nama dari data relasi 'user' yang kita sertakan di API
      parentName: json['user'] != null
          ? json['user']['name']
          : 'Nama Pemesan Disembunyikan',

      // Ambil data detail jika ada
      description: json['description'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      jobDate: json['job_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      offeredPrice: json['offered_price'],
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
