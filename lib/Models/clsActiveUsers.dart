class clsActiveUsers {
  final int id;
  final String name;
  final int phoneNumber;

  clsActiveUsers({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory clsActiveUsers.fromJson(Map<String, dynamic> json) {
    return clsActiveUsers(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}