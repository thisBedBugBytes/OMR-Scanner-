import 'package:dashboard_ui/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'activity_details_card.dart';
import 'package:dashboard_ui/data/side_menu_data.dart';
import 'package:dashboard_ui/widgets/timerscreen_widget.dart';
import 'UploadPDFScreen.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key, required this.isTeacher});

  final bool isTeacher; // Add this to take the role as a parameter

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData(isTeacher: widget.isTeacher); // Pass the role to SideMenuData

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: const Color(0xFF171821),
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) => buildMenuEntry(data, index),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
  final isSelected = selectedIndex == index;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(6.0),
      ),
      color: isSelected ? Colors.blueAccent : Colors.transparent,
    ),
    child: InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // Check if the clicked menu item is "Upload PDF" or "Timer"
        if (data.menu[index].title == 'Upload PDF') {
          // Navigate to the Upload PDF screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadPDFScreen()), // Ensure UploadPDFScreen is imported
          );
        } else if (data.menu[index].title == 'Timer') {
          // Navigate to the Timer screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimerScreen()), // Ensure TimerScreen is imported
          );
        } else {
          // For other menu items, handle their navigation here
        }
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            child: Icon(
              data.menu[index].icon,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          Text(
            data.menu[index].title,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
}