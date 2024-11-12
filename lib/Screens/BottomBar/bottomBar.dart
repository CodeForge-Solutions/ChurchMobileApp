import 'package:flutter/material.dart';
import '../../constants.dart'; // Ensure your primary color is defined here.

class CustomBottomNavBar extends StatelessWidget {
  final String selectedId;
  final ValueChanged<String> onItemTapped;
  final int accessLevel;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedId,
    required this.onItemTapped,
    required this.accessLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: _getNavItems(),
        currentIndex: _getSelectedIndex(),
        onTap: (index) => onItemTapped(_getNavItems()[index].label!), // Use label as ID
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  int _getSelectedIndex() {
    for (int i = 0; i < _getNavItems().length; i++) {
      if (_getNavItems()[i].label == selectedId) {
        return i;
      }
    }
    return 0; // Default to the first item if ID not found
  }

  List<BottomNavigationBarItem> _getNavItems() {
    List<BottomNavigationBarItem> items = [];

    if (accessLevel >= 1) {
      items.add(_buildNavItem(icon: Icons.dashboard, label: "Dashboard"));
    }
    if (accessLevel == 2) {
      items.add(_buildNavItem(icon: Icons.people, label: "Users"));
      items.add(_buildNavItem(icon: Icons.list_alt, label: "Requests"));
      items.add(_buildNavItem(icon: Icons.cake, label: "Birthdays"));
    }
    if (accessLevel >= 1) {
      items.add(_buildNavItem(icon: Icons.settings, label: "Settings"));
    }

    return items;
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
  }) {
    bool isSelected = selectedId == label;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: isSelected ? 55 : 40,
        height: isSelected ? 55 : 40,
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 3,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Icon(
          icon,
          size: isSelected ? 30 : 26,
          color: isSelected ? kPrimaryColor : Colors.grey.shade500,
        ),
      ),
      label: label,
    );
  }
}
