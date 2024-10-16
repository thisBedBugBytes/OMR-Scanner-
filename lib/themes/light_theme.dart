import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColor.primaryRed,
  scaffoldBackgroundColor: AppColor.backgroundLight,
  appBarTheme: AppBarTheme(
    color: AppColor.primaryRed,
    iconTheme: IconThemeData(color: AppColor.textLight),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(color: AppColor.textLight, fontSize: 40),
    bodyLarge: TextStyle(color: AppColor.textLight),
  ),
  buttonTheme: ButtonThemeData(buttonColor: AppColor.primaryRed),
);