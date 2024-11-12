import 'dart:convert';
import 'package:church_mobile_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../shared_preference.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Controllers for text input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final int? userId = SharedPrefs.getInt(SharedPrefs.userId);
    final String? token = SharedPrefs.getString(SharedPrefs.token);
    final url = Uri.parse('${baseUrl}user/getUserById?userId=$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Add the authorization header
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccess']) {
          final userData = data['data'];
          setState(() {
            _nameController.text = userData['name'] ?? '';
            _dobController.text = userData['dateOfBirth'] ?? '';
            _addressController.text = userData['address'] ?? '';
            _phoneController.text = userData['phoneNumber'] ?? '';
            _genderController.text = userData['gender'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _countryController.text = userData['country'] ?? '';
            _cityController.text = userData['city'] ?? '';
            _postalCodeController.text = userData['postalCode'] ?? '';
            _occupationController.text = userData['occupation'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            _buildProfileField("Name", _nameController, TextInputType.name),
            _buildProfileField("Date of Birth", _dobController, TextInputType.datetime),
            _buildProfileField("Address", _addressController, TextInputType.streetAddress),
            _buildProfileField("Phone Number", _phoneController, TextInputType.phone),
            _buildProfileField("Gender", _genderController, TextInputType.text),
            _buildProfileField("Email", _emailController, TextInputType.emailAddress),
            _buildProfileField("Country", _countryController, TextInputType.text),
            _buildProfileField("City", _cityController, TextInputType.text),
            _buildProfileField("Postal Code", _postalCodeController, TextInputType.number),
            _buildProfileField("Occupation", _occupationController, TextInputType.text),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, TextInputType keyboardType, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: true, // Make fields read-only as editing is removed
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
        ),
      ),
    );
  }
}
