class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  // --- FIELD BARU DITAMBAHKAN ---
  final String? phoneNumber;
  final String? address;
  final double? latitude;
  final double? longitude;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.role,
    // -- Tambahkan ke constructor --
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
      // --- Parsing data baru dari JSON ---
      phoneNumber: json['phone_number'],
      address: json['address'],
      latitude: double.tryParse(json['latitude'].toString()),
      longitude: double.tryParse(json['longitude'].toString()),
    );
  }
}
