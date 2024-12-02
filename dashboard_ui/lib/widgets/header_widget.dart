import 'package:dashboard_ui/const/constant.dart'; 
import 'package:dashboard_ui/util/responsive.dart' as responsive; // Add alias for the import
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!responsive.Responsive.isDesktop(context)) // Use prefix for responsive
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.menu,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
            ),
          ),
        if (!responsive.Responsive.isMobile(context)) // Use prefix for responsive
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: cardBackgroundColor,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                hintText: 'Search',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 21,
                ),
              ),
            ),
          ),
        if (responsive.Responsive.isMobile(context)) // Use prefix for responsive
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 25,
                ),
                onPressed: () {},
              ),
              InkWell(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    "assets/images/avatar.png",
                    width: 32,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}