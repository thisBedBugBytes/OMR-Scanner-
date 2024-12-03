import 'package:flutter/material.dart';

class CurrentCourses {
  final String icon; // Path to the icon asset
  final String title; // Text label for the course
  final Widget destination;
  const CurrentCourses({
    required this.icon,
    required this.title,
    required this.destination,
  });
}