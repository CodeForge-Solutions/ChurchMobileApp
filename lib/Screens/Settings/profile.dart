import 'package:flutter/material.dart';
import '../../constants.dart'; // Assuming you store colors & gradients here

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isEditing = false; // Controls Edit mode

  // Controllers to manage text input fields
  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _dobController = TextEditingController(text: "1990-01-01");
  final TextEditingController _addressController = TextEditingController(text: "123 Main Street");
  final TextEditingController _phoneController = TextEditingController(text: "9876543210");
  final TextEditingController _genderController = TextEditingController(text: "M");
  final TextEditingController _emailController = TextEditingController(text: "john@example.com");
  final TextEditingController _countryController = TextEditingController(text: "USA");
  final TextEditingController _cityController = TextEditingController(text: "New York");
  final TextEditingController _postalCodeController = TextEditingController(text: "10001");
  final TextEditingController _occupationController = TextEditingController(text: "Engineer");

  // Toggles the edit mode
  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // Saves the edited details (For now, just closes edit mode)
  void _saveDetails() {
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile",style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image (Placeholder)
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Name Field
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

            // Save and Cancel Buttons (Visible only in Edit Mode)
            if (_isEditing)
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Save Button with Gradient
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor], // From constants.dart
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: borderRadius,
            ),
            child: ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(120, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        // Cancel Button with Red Accent
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              onPressed: _toggleEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shadowColor: Colors.redAccent.withOpacity(0.5),
                minimumSize: const Size(120, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    ),
          ],
        ),
      ),
    );
  }

  // Reusable widget to build a profile field
  Widget _buildProfileField(String label, TextEditingController controller, TextInputType keyboardType, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: !_isEditing, // Editable only in edit mode
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

  // Reusable widget to build a gradient button
  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [gradientStartColor, gradientEndColor], // From constants.dart
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(120, 50),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
