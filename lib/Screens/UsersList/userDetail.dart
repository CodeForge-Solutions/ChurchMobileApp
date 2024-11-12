import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/clsMstUser.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;

import '../../shared_preference.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  clsMstUser? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final token = SharedPrefs.getString(SharedPrefs.token);
    final url = Uri.parse('${baseUrl}user/getUserById?userId=${widget.userId}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['isSuccess'] == true) {
          setState(() {
            user = clsMstUser.fromJson(responseData['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showToast(context, responseData['message']);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showToast(context, 'Failed to load');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showToast(context, 'An error occurred');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("User Details"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user == null) {
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
            _buildDetailItem('Phone', user!.phoneNumber),
            _buildDetailItem('Email', user!.email),
            _buildDetailItem('Date of Birth',user!.dateOfBirth),
            _buildDetailItem('Password', user!.password),
            _buildDetailItem('Address', user!.address),
            _buildDetailItem('Country', user!.country),
            _buildDetailItem('City', user!.city),
            _buildDetailItem('Postal Code', user!.postalCode),
            _buildDetailItem('Occupation', user!.occupation),
            _buildDetailItem('Admin Status', user!.isAdmin),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _makePhoneCall(user!.phoneNumber);
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
