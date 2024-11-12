import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../shared_preference.dart';
import '../Login/login.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _confirmationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final int? userId = SharedPrefs.getInt(SharedPrefs.userId);
        final String? token = SharedPrefs.getString(SharedPrefs.token); // Retrieve the token

        final response = await http.delete(
          Uri.parse('${baseUrl}user/deleteUserById?userId=$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Add Authorization header
          },
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          if (responseData['isSuccess'] == true) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            // Show failure message if API did not succeed
            showToast(context, responseData['message']);
          }
        } else {
          showToast(context, responseData['message']);
        }
      } catch (e) {
        showToast(context, 'Failed to delete account');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delete Account",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/change_password.jpg',
              height: 300,
              width: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: kSpacing * 2),
            Text(
              'Account Deletion Warning',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpacing),
            const Text(
              'After temporary deletion, your details will be removed after 90 days of inactivity.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kUserNameFontSize),
            ),
            const SizedBox(height: kSpacing * 2),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _confirmationController,
                decoration: customInputDecoration(
                  "Type 'confirm' to delete",
                  Icons.warning_amber_rounded,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please type "confirm"';
                  } else if (value != 'confirm') {
                    return 'Type "confirm" to proceed';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: kSpacing * 2),
            _isLoading
                ? const CircularProgressIndicator()
                : buildGradientButton(
              child: const Text(
                "Delete Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: _deleteAccount,
            ),
          ],
        ),
      ),
    );
  }
}
