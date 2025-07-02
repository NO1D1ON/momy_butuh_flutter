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
      // Gunakan tryParse untuk mengonversi String ke int dengan aman
      id: int.tryParse(json['id'].toString()) ?? 0,

      name: json['name'] ?? 'Nama Tidak Ditemukan',
      email: json['email'] ?? 'Email Tidak Ditemukan',

      // Gunakan tryParse untuk saldo juga
      balance: int.tryParse(json['balance'].toString()) ?? 0,

      phoneNumber: json['phone_number'],
      address: json['address'],

      // Gunakan tryParse untuk latitude dan longitude
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }
}
