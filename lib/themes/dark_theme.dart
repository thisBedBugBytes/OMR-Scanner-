import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColor.primaryMaroon,
  scaffoldBackgroundColor: AppColor.backgroundDark,
  appBarTheme: AppBarTheme(
    color: AppColor.primaryMaroon,
    iconTheme: IconThemeData(color: AppColor.textDark),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(color: AppColor.textDark, fontSize: 40), // Updated
    bodyLarge: TextStyle(color: AppColor.textDark), // Updated
  ),
  buttonTheme: ButtonThemeData(buttonColor: AppColor.primaryMaroon),
);