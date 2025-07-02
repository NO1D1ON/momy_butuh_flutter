class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? role;

  // --- FIELD TAMBAHAN ---
  final String? phoneNumber;
  final String? address;
  final double? latitude;
  final double? longitude;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
  });

  /// Factory constructor untuk membuat instance dari JSON.
  /// Kode ini sudah diperbaiki untuk menangani angka yang dikirim sebagai String dari API.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Mengonversi 'id' dengan aman, baik itu String, int, atau null.
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,

      name: json['name'],
      email: json['email'],
      role: json['role'],
      phoneNumber: json['phone_number'],
      address: json['address'],

      // Mengonversi 'latitude' dengan aman.
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,

      // Mengonversi 'longitude' dengan aman.
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }

  /// Mengubah objek UserModel menjadi Map, berguna untuk serialisasi.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone_number': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
