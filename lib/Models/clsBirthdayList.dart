class clsBirthdayList {
  final int id;
  final String name;
  final DateTime birthday;
  final String? phoneNumber;

  clsBirthdayList({
    required this.id,
    required this.name,
    required this.birthday,
    this.phoneNumber,
  });
}