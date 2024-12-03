import 'package:dashboard_ui/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:dashboard_ui/widgets/dashboard_widget.dart';
import 'package:dashboard_ui/util/responsive.dart';



class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      drawer: !isDesktop
          ? const SizedBox(
              width: 250,
              child: SideMenuWidget(), // Use the defined SideMenuWidget
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: const SideMenuWidget(), // Use the defined SideMenuWidget here
              ),
            Expanded(
              flex: 8, // Adjusted flex to ensure proper layout
              child:  DashboardWidget(),
            ),
          ],
        ),
      ),
    );
  }
}