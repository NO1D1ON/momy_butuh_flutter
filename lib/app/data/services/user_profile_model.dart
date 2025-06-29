// Model untuk menampung data profil umum (bisa untuk User dan Babysitter)
class UserProfile {
  final int id;
  final String name;
  final String email;
  final int balance;
  final String? phoneNumber;
  final String? address;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    this.phoneNumber,
    this.address,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? 'Nama Tidak Ditemukan',
      email: json['email'] ?? 'Email Tidak Ditemukan',
      // Pastikan ada nilai default jika balance null
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }
}
