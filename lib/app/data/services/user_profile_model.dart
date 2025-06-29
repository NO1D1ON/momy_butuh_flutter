class UserProfile {
  final int id;
  final String name;
  final String email;
  final int balance;
  final String? phoneNumber;
  final String? address;
  final double? latitude; // <-- TAMBAHKAN INI
  final double? longitude; // <-- TAMBAHKAN INI

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? 'Nama Tidak Ditemukan',
      email: json['email'] ?? 'Email Tidak Ditemukan',
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      phoneNumber: json['phone_number'],
      address: json['address'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
