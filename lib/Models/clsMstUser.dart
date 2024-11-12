class clsMstUser {
  final String name;
  final String dateOfBirth;
  final String address;
  final String phoneNumber;
  final String gender;
  final String email;
  final String password;
  final String country;
  final String city;
  final String postalCode;
  final String occupation;
  final String isAdmin;

  clsMstUser({
    required this.name,
    required this.dateOfBirth,
    required this.address,
    required this.phoneNumber,
    required this.gender,
    required this.email,
    required this.password,
    required this.country,
    required this.city,
    required this.postalCode,
    required this.occupation,
    required this.isAdmin,
  });

  // Factory constructor to create clsMstUser from JSON
  factory clsMstUser.fromJson(Map<String, dynamic> json) {
    return clsMstUser(
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      email: json['email'] ?? '',
      password: json['password'],
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      occupation: json['occupation'] ?? '',
      isAdmin: json['isAdmin'],
    );
  }
}
