import 'package:flutter/material.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:dashboard_ui/util/responsive.dart';  // Responsive class import
import 'side_menu_widget.dart'; // Ensure you have the side menu widget
import 'header_widget.dart'; // Your header widget
import 'activity_details_card.dart'; // Your card widget


class DashboardWidget extends StatelessWidget {
    DashboardWidget({super.key});
   Offset position = const Offset(200.0, 450.0);
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
     child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(height: 18),
              HeaderWidget(),
              SizedBox(height: 18),
              ActivityDetailsCard(),
              SizedBox(height: 18)
            ],
          ),
        )
    );
          //);
  }
}

