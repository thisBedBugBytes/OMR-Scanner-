import 'package:flutter/material.dart';

// Colors
const cardBackgroundColor = Color(0xFF21222D);
const primaryColor = Color(0xFF781131);
const secondaryColor = Color(0xFFFFFFFF);
const backgroundColor = Color(0xFF15131C);
const selectionColor = Color(0xFF88B2AC);
const defaultBackgroundColor = Colors.grey;  // Updated to a general color for all screens
const appBarColor = Colors.grey;  // AppBar background color
const drawerBackgroundColor = Colors.grey;  // Background color for the Drawer
const drawerTextColor = TextStyle(color: Colors.grey);  // Text color for Drawer items

// Padding & Margin Constants
const double defaultPadding = 20.0;
const EdgeInsets tilePadding = EdgeInsets.only(left: 8.0, right: 8, top: 8);

// AppBar Constants
var myAppBar = AppBar(
  backgroundColor: appBarColor,
  title: Text(' '),
  centerTitle: false,
);

// Drawer Constants
var myDrawer = Drawer(
  backgroundColor: drawerBackgroundColor,
  elevation: 0,
  child: Column(
    children: [
      DrawerHeader(
        child: Icon(
          Icons.favorite,
          size: 64,
        ),
      ),
      // ListTile Entries for Drawer Menu
      _buildDrawerListTile(Icons.home, 'D A S H B O A R D'),
      _buildDrawerListTile(Icons.settings, 'S E T T I N G S'),
      _buildDrawerListTile(Icons.info, 'A B O U T'),
      _buildDrawerListTile(Icons.logout, 'L O G O U T'),
    ],
  ),
);

// Helper function to build Drawer ListTiles
Widget _buildDrawerListTile(IconData icon, String text) {
  return Padding(
    padding: tilePadding,
    child: ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: drawerTextColor,
      ),
    ),
  );
}

// Responsive Layout Considerations (for tablet and mobile)
class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
}



