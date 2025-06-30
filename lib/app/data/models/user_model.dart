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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }

  // ✅ Tambahkan toJson() untuk serialisasi
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
