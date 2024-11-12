import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_preference.dart';
import '../BirthdayList/birthdayList.dart';
import '../BottomBar/bottomBar.dart';
import '../Components/background.dart'; // Import Background widget
import '../NoAuth/noAuth.dart';
import '../RequestList/requestList.dart';
import '../RequestRejected/requestRejected.dart';
import '../Settings/settings.dart';
import '../UsersList/usersList.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedId = "Dashboard"; // Default to "dashboard"
  int? _accessLevel; // Access level retrieved from SharedPreferences
  Map<String, Widget> _pages = {};

  @override
  void initState() {
    super.initState();
    _loadAccessLevel();
  }

  Future<void> _loadAccessLevel() async {
    _accessLevel = await SharedPrefs.getInt('userAccessLevel') ?? 0;
    if (_accessLevel == -1) {
      // If access level is -1, navigate to RequestRejectedPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RequestRejectedPage()),
      );
      return; // Don't continue with the page setup if access level is -1
    }

    _setupPages();
    if (_accessLevel == 0) {
      // If access level is 0, navigate to NoAuthPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NoAuthPage()),
      );
    } else {
      setState(() {}); // Rebuild to display the pages based on the access level
    }
  }

  void _setupPages() {
    _pages = {
      "Dashboard": const Center(child: Text("Dashboard", style: TextStyle(fontSize: 24))),
      if (_accessLevel != null && _accessLevel! >= 1) "Users": const ActiveUsersListScreen(),
      if (_accessLevel == 2) "Requests": const RequestListScreen(),
      if (_accessLevel == 2) "Birthdays": const BirthdayListScreen(),
      if (_accessLevel != null && _accessLevel! >= 1) "Settings": const SettingsPage(),
    };
  }

  void _onItemTapped(String id) {
    setState(() {
      _selectedId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _accessLevel == null
            ? const Center(child: CircularProgressIndicator()) // Show loading until access level is loaded
            : _pages[_selectedId] ?? const Center(child: Text("Page not found")), // Display selected page
        bottomNavigationBar: _accessLevel == null || _accessLevel == 0
            ? null
            : CustomBottomNavBar(
          selectedId: _selectedId,
          onItemTapped: _onItemTapped,
          accessLevel: _accessLevel!, // Pass access level to BottomNavBar
        ),
      ),
    );
  }
}
