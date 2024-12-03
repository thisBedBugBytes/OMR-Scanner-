import 'package:flutter/material.dart';
import 'package:dashboard_ui/util/responsive.dart';  // Responsive class import
import 'side_menu_widget.dart'; // Ensure you have the side menu widget
import 'header_widget.dart'; // Your header widget
import 'activity_details_card.dart'; // Your card widget

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:  SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(height: 18),
              HeaderWidget(),
              SizedBox(height: 18),
              ActivityDetailsCard(),
              SizedBox(height: 18),

            ],
          ),
        ),
      ),
    );
  }
}