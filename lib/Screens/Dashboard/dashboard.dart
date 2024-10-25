import 'package:flutter/material.dart';
import '../BirthdayList/birthdayList.dart';
import '../BottomBar/bottomBar.dart';
import '../Components/background.dart';
import '../RequestList/requestList.dart';
import '../Settings/settings.dart';
import '../UsersList/usersList.dart';  // Import Background widget

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Dashboard", style: TextStyle(fontSize: 24))),
    ActiveUsersListScreen(),
    RequestListScreen(),
    BirthdayListScreen(),
    SettingsPage(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _pages[_selectedIndex],  // Display selected page
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
