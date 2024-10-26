import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../constants.dart';
import 'sendWishes.dart';

class BirthdayListScreen extends StatefulWidget {
  const BirthdayListScreen({Key? key}) : super(key: key);

  @override
  _BirthdayListScreenState createState() => _BirthdayListScreenState();
}

class _BirthdayListScreenState extends State<BirthdayListScreen> {
  // List of users with their birthdays
  final List<ApplicationUser> users = [
    ApplicationUser(id: '1', name: 'Alice', birthday: DateTime.now(), phoneNumber: '123-456-7890'),
    ApplicationUser(id: '2', name: 'Bob', birthday: DateTime.now().subtract(const Duration(days: 1)), phoneNumber: '987-654-3210'),
    ApplicationUser(id: '3', name: 'Charlie', birthday: DateTime.now().add(const Duration(days: 1)), phoneNumber: '555-555-5555'),
    ApplicationUser(id: '4', name: 'Alice1', birthday: DateTime.now(), phoneNumber: '123-456-7890'),
    ApplicationUser(id: '5', name: 'Bob2', birthday: DateTime.now().subtract(const Duration(days: 1)), phoneNumber: '987-654-3210'),
    ApplicationUser(id: '6', name: 'Charlie2', birthday: DateTime.now().add(const Duration(days: 1)), phoneNumber: '555-555-5555'),
  ];

  String _selectedCategory = 'Today'; // Default selected category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Birthdays",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryButton('Yesterday'),
                  _buildCategoryButton('Today'),
                  _buildCategoryButton('Tomorrow'),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: _getFilteredBirthdays()
                  .map((user) => BirthdayCard(user: user))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCategory == category
            ? theme.primaryColor
            : theme.colorScheme.secondary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: _selectedCategory == category
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSecondary,
        ),
      ),
    );
  }

  List<ApplicationUser> _getFilteredBirthdays() {
    final today = DateTime.now();
    return users.where((user) {
      switch (_selectedCategory) {
        case 'Today':
          return _isSameDay(user.birthday, today);
        case 'Yesterday':
          return _isSameDay(user.birthday, today.subtract(const Duration(days: 1)));
        case 'Tomorrow':
          return _isSameDay(user.birthday, today.add(const Duration(days: 1)));
        default:
          return false;
      }
    }).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class ApplicationUser {
  final String id;
  final String name;
  final DateTime birthday;
  final String phoneNumber;

  ApplicationUser({
    required this.id,
    required this.name,
    required this.birthday,
    required this.phoneNumber,
  });
}

class BirthdayCard extends StatelessWidget {
  final ApplicationUser user;

  const BirthdayCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SendWishesScreen(user: user)),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(kCardMargin),
        child: Padding(
          padding: const EdgeInsets.all(kCardPadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: kUserNameFontSize, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Birthday: ${DateFormat('dd-MM-yyyy').format(user.birthday)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text('Phone: ${user.phoneNumber}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
