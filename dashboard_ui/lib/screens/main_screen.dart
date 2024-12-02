import 'package:flutter/material.dart';
import 'package:dashboard_ui/widgets/side_menu_widget.dart';
import 'package:dashboard_ui/widgets/dashboard_widget.dart';
import 'package:dashboard_ui/util/responsive.dart';


class MainScreen extends StatelessWidget {
   MainScreen({super.key});
  Offset position = const Offset(20.0, 20.0);
  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    // Assume isTeacher is true or false based on user role
    bool isTeacher = true;  // Set to 'true' for Teacher, 'false' for Student

    return Scaffold(
      drawer: !isDesktop
          ? SizedBox(
              width: 250,
              child: SideMenuWidget(isTeacher: isTeacher),  // Pass the isTeacher value here
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SideMenuWidget(isTeacher: isTeacher),  // Pass isTeacher here as well
              ),
            Expanded(
              flex: 8,
              child:   DashboardWidget(),  // Your dashboard content here
            ),

          ],
        ),
      ),
    );
  }
}