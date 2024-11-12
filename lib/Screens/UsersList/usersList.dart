import 'dart:convert';

import 'package:flutter/material.dart';
import '../../Models/clsActiveUsers.dart';
import '../../constants.dart';
import '../../shared_preference.dart';
import 'userDetail.dart';
import 'package:http/http.dart' as http;

class ActiveUsersListScreen extends StatefulWidget {
  const ActiveUsersListScreen({Key? key}) : super(key: key);

  @override
  _ActiveUsersListScreenState createState() => _ActiveUsersListScreenState();
}

class _ActiveUsersListScreenState extends State<ActiveUsersListScreen> {
  List<clsActiveUsers> activeUsers = [];

  @override
  void initState() {
    super.initState();
    fetchActiveUsers();
  }

  Future<void> fetchActiveUsers() async {
    final int? sessionEuid = SharedPrefs.getInt(SharedPrefs.userId);
    final String apiUrl = '${baseUrl}user/getActiveUsersList?iUserId=$sessionEuid';
    final String? token = SharedPrefs.getString(SharedPrefs.token);

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonResponse['isSuccess'] == true) {
          var bodyData = jsonResponse['data'];
          if (bodyData != "") {
            final List<dynamic> data = bodyData;
            setState(() {
              activeUsers = data.map((json) => clsActiveUsers.fromJson(json)).toList();
            });
          } else {
            setState(() {
              activeUsers = [];
            });
          }
        } else {
          showToast(context, jsonResponse['message']);
        }
      } else {
        showToast(context, jsonResponse['message']);
      }
    } catch (error) {
      showToast(context, 'Something went wrong.');
    }
  }


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
      body: RefreshIndicator(
        onRefresh: fetchActiveUsers, // Call the fetch function on refresh
        child: activeUsers.isEmpty
            ? const Center(child: Text("No active users available."))
            : ListView.builder(
          itemCount: activeUsers.length,
          itemBuilder: (context, index) {
            final user = activeUsers[index];
            return _buildUserCard(user);
          },
        ),
      ),
    );
  }

  Widget _buildUserCard(clsActiveUsers user) {
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
        margin: const EdgeInsets.all(kCardMargin),
        // Ensure kCardMargin is defined in constants
        child: Padding(
          padding: const EdgeInsets.all(kCardPadding),
          // Ensure kCardPadding is defined in constants
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
                        fontSize: kUserNameFontSize,
                        // Ensure kUserNameFontSize is defined in constants
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: kSpacing),
                    // Ensure kSpacing is defined in constants
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

  void _confirmDeletion(int userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
              "Are you sure you want to deactivate this account?"),
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
                Navigator.of(context).pop(); // Call the toast function here
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(int userId) async {
    final String? token = SharedPrefs.getString(SharedPrefs.token);

    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}user/deleteUserById?userId=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['isSuccess'] == true) {
        setState(() {
          fetchActiveUsers(); // Refresh the list of active users after deletion
        });
        showToast(context, jsonResponse['message']);
      } else {
        showToast(context, jsonResponse['message']);
      }
    } catch (error) {
      showToast(context, 'Something went wrong.');
    }
  }

}
