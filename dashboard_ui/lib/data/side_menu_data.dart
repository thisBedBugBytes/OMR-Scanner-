import 'package:flutter/material.dart';
import 'package:dashboard_ui/models/menu_model.dart';

class SideMenuData {
  final bool isTeacher; // Add a flag to check if the user is a teacher

  SideMenuData({required this.isTeacher});

  List<MenuModel> get menu {
    // Return different menu options based on the role
    if (isTeacher) {
      return const <MenuModel>[
        MenuModel(icon: Icons.home, title: 'Teacher Dashboard'),
        MenuModel(icon: Icons.person, title: 'Profile'),
        MenuModel(icon: Icons.menu_book, title: 'Courses'),
        MenuModel(icon: Icons.bar_chart, title: 'Grades'),
        MenuModel(icon: Icons.settings, title: 'Settings'),
        MenuModel(icon: Icons.upload_file, title: 'Upload PDF'), // New option for Teacher
        MenuModel(icon: Icons.timer, title: 'Timer'), // New option for Teacher
        MenuModel(icon: Icons.logout, title: 'Sign Out'),
      ];
    } else {
      return const <MenuModel>[
        MenuModel(icon: Icons.home, title: 'Student Dashboard'),
        MenuModel(icon: Icons.person, title: 'Profile'),
        MenuModel(icon: Icons.menu_book, title: 'Courses'),
        MenuModel(icon: Icons.bar_chart, title: 'Grades'),
        MenuModel(icon: Icons.upload_file, title: 'Upload OMR'),
        MenuModel(icon: Icons.settings, title: 'Settings'),
        MenuModel(icon: Icons.logout, title: 'Sign Out'),
      ];
    }
  }
}