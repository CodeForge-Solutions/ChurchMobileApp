import 'package:flutter/material.dart';
import '../../constants.dart'; // Ensure your primary color is defined here.

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
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
            offset: const Offset(0, -8), // Softer shadow above.
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: [
          _buildNavItem(icon: Icons.dashboard, label: "Dashboard", index: 0),
          _buildNavItem(icon: Icons.people, label: "Users", index: 1),
          _buildNavItem(icon: Icons.list_alt, label: "Requests", index: 2),
          _buildNavItem(icon: Icons.cake, label: "Birthdays", index: 3),
          _buildNavItem(icon: Icons.settings, label: "Settings", index: 4),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
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

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = selectedIndex == index;

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
            )
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
