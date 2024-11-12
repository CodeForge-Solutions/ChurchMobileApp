class clsSignUp {
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

  clsSignUp({
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
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'DateOfBirth': dateOfBirth,
      'Address': address,
      'PhoneNumber': phoneNumber,
      'Gender': gender,
      'Email': email,
      'Password': password,
      'Country': country,
      'City': city,
      'PostalCode': postalCode,
      'Occupation': occupation,
    };
  }
}
