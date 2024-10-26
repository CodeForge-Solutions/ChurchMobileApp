import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class ActiveUser {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final DateTime dateOfBirth;
  final String password;
  final String? address; // Optional field
  final String? country; // Optional field
  final String? city; // Optional field
  final int? postalCode; // Optional field
  final String? occupation; // Optional field

  ActiveUser({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.dateOfBirth,
    required this.password,
    this.address,
    this.country,
    this.city,
    this.postalCode,
    this.occupation,
  });
}

class UserDetailScreen extends StatelessWidget {
  final String userId; // Only userId passed

  const UserDetailScreen({Key? key, required this.userId}) : super(key: key);

  // Mock Data (Simulating a database or API call)
  ActiveUser? getUserById(String id) {
    final users = [
      ActiveUser(
        id: '1',
        name: 'Alice',
        phoneNumber: '123-456-7890',
        email: 'alice@example.com',
        dateOfBirth: DateTime(1995, 4, 10),
        password: 'password123',
        address: '123 Main St', // Mock address
        country: 'USA', // Mock country
        city: 'New York', // Mock city
        postalCode: 10001, // Mock postal code
        occupation: 'Software Developer', // Mock occupation
      ),
      ActiveUser(
        id: '2',
        name: 'Bob',
        phoneNumber: '098-765-4321',
        email: 'bob@example.com',
        dateOfBirth: DateTime(1988, 8, 15),
        password: 'password456',
        address: '456 Elm St',
        country: 'Canada',
        city: 'Toronto',
        postalCode: 12345,
        occupation: 'Designer',
      ),
    ];

    return users.firstWhere(
          (user) => user.id == id,
      orElse: () => ActiveUser(
        id: '0',
        name: 'Unknown',
        phoneNumber: 'N/A',
        email: 'N/A',
        dateOfBirth: DateTime.now(), // You can set a default date if necessary
        password: 'N/A',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = getUserById(userId); // Fetch user by id

    if (user?.id == '0') {
      return Scaffold(
        appBar: AppBar(
          title: const Text("User Details"),
        ),
        body: const Center(
          child: Text("User not found."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDetailPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Name', user!.name),
            _buildDetailItem('Phone', user.phoneNumber),
            _buildDetailItem('Email', user.email),
            _buildDetailItem(
              'Date of Birth',
              DateFormat('yyyy-MM-dd').format(user.dateOfBirth),
            ),
            _buildDetailItem('Password', user.password), // Display password
            _buildDetailItem('Address', user.address ?? 'N/A'), // Display address
            _buildDetailItem('Country', user.country ?? 'N/A'), // Display country
            _buildDetailItem('City', user.city ?? 'N/A'), // Display city
            _buildDetailItem('Postal Code', user.postalCode?.toString() ?? 'N/A'), // Display postal code
            _buildDetailItem('Occupation', user.occupation ?? 'N/A'), // Display occupation

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to call or message the user
              },
              child: const Text('Call User'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Increased text size
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 18), // Increased text size
            ),
          ),
        ],
      ),
    );
  }
}
