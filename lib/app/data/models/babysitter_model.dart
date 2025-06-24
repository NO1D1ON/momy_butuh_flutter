// Model untuk data babysitter
class Babysitter {
  final int id;
  final String name;
  final int age;
  final String address;
  final String bio;
  final int ratePerHour;

  Babysitter({
    required this.id,
    required this.name,
    required this.age,
    required this.address,
    required this.bio,
    required this.ratePerHour,
  });

  // Factory constructor untuk membuat instance Babysitter dari JSON
  factory Babysitter.fromJson(Map<String, dynamic> json) {
    return Babysitter(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      address: json['address'] ?? 'Alamat tidak tersedia',
      bio: json['bio'] ?? 'Bio tidak tersedia',
      ratePerHour: json['rate_per_hour'],
    );
  }
}
