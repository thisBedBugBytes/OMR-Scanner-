import 'package:dashboard_ui/models/menu_model.dart';
import 'package:flutter/material.dart';


class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Student Dashboard'),
    MenuModel(icon: Icons.person, title: 'Profile'),
    MenuModel(icon: Icons.menu_book, title: 'Courses'),
    MenuModel(icon: Icons.bar_chart, title: 'Grades'),
    MenuModel(icon: Icons.upload_file, title: 'Upload OMR'),
    MenuModel(icon: Icons.settings, title: 'Settings'),
    MenuModel(icon: Icons.groups, title: 'Faculty Lists'),
    // Keep sign-out icon at the bottom
    MenuModel(icon: Icons.logout, title: 'Sign Out'),
  ];
}