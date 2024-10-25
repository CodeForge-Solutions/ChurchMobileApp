import 'package:flutter/material.dart';
import '../../constants.dart';
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

  void _deleteAccount() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
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
            // Top Image
            Image.asset(
              'assets/images/change_password.jpg', // Use your image path
              height: 300,
              width: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: kSpacing * 2),

            // Heading Text
            Text(
              'Account Deletion Warning',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpacing),

            // Warning Message
            const Text(
              'After temporary deletion, your details will be removed after 90 days of inactivity.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kUserNameFontSize),
            ),
            const SizedBox(height: kSpacing * 2),

            // Confirmation TextField
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

            // Delete Account Button with Gradient
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
