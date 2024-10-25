import 'package:flutter/material.dart';
import '../../constants.dart';
import '../BirthdayList/sendWishes.dart';
import 'userDetail.dart';

/// Active User Model
class ActiveUser {
  final String id;
  final String name;
  final String phoneNumber;

  ActiveUser({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });
}

class ActiveUsersListScreen extends StatefulWidget {
  const ActiveUsersListScreen({Key? key}) : super(key: key);

  @override
  _ActiveUsersListScreenState createState() => _ActiveUsersListScreenState();
}

class _ActiveUsersListScreenState extends State<ActiveUsersListScreen> {
  final List<ActiveUser> activeUsers = [
    ActiveUser(id: '1', name: 'Alice', phoneNumber: '123-456-7890'),
    ActiveUser(id: '2', name: 'Bob', phoneNumber: '987-654-3210'),
    ActiveUser(id: '3', name: 'Charlie', phoneNumber: '555-555-5556'),
    ActiveUser(id: '4', name: 'Diana', phoneNumber: '111-222-3334'),
    ActiveUser(id: '5', name: 'Eve', phoneNumber: '666-777-8885'),
    ActiveUser(id: '6', name: 'Frank', phoneNumber: '666-777-8886'),
    ActiveUser(id: '7', name: 'Grace', phoneNumber: '666-777-8887'),
    ActiveUser(id: '8', name: 'Heidi', phoneNumber: '666-777-8888'),
    ActiveUser(id: '9', name: 'Ivan', phoneNumber: '666-777-8889'),
    ActiveUser(id: '10', name: 'Judy', phoneNumber: '666-777-8890'),
    ActiveUser(id: '11', name: 'Karl', phoneNumber: '666-777-8891'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Active Users",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: kAppBarFontSize, // Ensure kAppBarFontSize is defined in constants
          ),
        ),
      ),
      body: activeUsers.isEmpty
          ? const Center(child: Text("No active users available."))
          : ListView.builder(
        itemCount: activeUsers.length,
        itemBuilder: (context, index) {
          final user = activeUsers[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(ActiveUser user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailScreen(userId: user.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(kCardMargin), // Ensure kCardMargin is defined in constants
        child: Padding(
          padding: const EdgeInsets.all(kCardPadding), // Ensure kCardPadding is defined in constants
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: kUserNameFontSize, // Ensure kUserNameFontSize is defined in constants
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: kSpacing), // Ensure kSpacing is defined in constants
                    Text('Phone: ${user.phoneNumber}'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _confirmDeletion(user.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeletion(String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to deactivate this account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(userId);
                Navigator.of(context).pop();
                showToast(context,"User has been deactivated."); // Call the toast function here
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(String userId) {
    setState(() {
      activeUsers.removeWhere((user) => user.id == userId);
    });
  }
}
