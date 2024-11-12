import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../Models/clsBirthdayList.dart';
import '../../constants.dart';
import '../../shared_preference.dart';
import 'sendWishes.dart';

class BirthdayListScreen extends StatefulWidget {
  const BirthdayListScreen({Key? key}) : super(key: key);

  @override
  _BirthdayListScreenState createState() => _BirthdayListScreenState();
}

class _BirthdayListScreenState extends State<BirthdayListScreen> {
  List<clsBirthdayList> users = [];
  String _selectedCategory = 'Today'; // Default selected category

  @override
  void initState() {
    super.initState();
    fetchBirthdays();
  }

  Future<void> fetchBirthdays() async {
    const url = '${baseUrl}user/getBirthdayForDays';
    final String? token = SharedPrefs.getString(SharedPrefs.token);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['isSuccess']) {
          final List<clsBirthdayList> loadedUsers = (jsonResponse['data'] as List).map((data) {
            return clsBirthdayList(
              id: data['userId'],
              name: data['userName'],
              birthday: DateFormat("dd-MM-yyyy").parse(data['dateOfBirth']),
              phoneNumber: data['phoneNumber'] ?? '',
            );
          }).toList();

          setState(() {
            users = loadedUsers;
          });
        } else {
          showToast(context, jsonResponse['message']);
        }
      } else {
        showToast(context, 'Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      showToast(context, 'An error occurred while loading data.');
    }
  }


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

  List<clsBirthdayList> _getFilteredBirthdays() {
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

class BirthdayCard extends StatelessWidget {
  final clsBirthdayList user;

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
