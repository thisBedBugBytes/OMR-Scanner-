import 'package:dashboard_ui/models/Current_courses.dart';
import 'package:dashboard_ui/screens/main_screen.dart';
import 'package:dashboard_ui/util/scanner.dart';
import 'package:flutter/material.dart';


import 'package:dashboard_ui/models/Current_courses.dart';

class CourseDetails {
  static const List<CurrentCourses> courses = [
    CurrentCourses(
      icon: 'assets/images/grade_history1.png',
      title: 'Grade History',
      destination: MainScreen()
    ),
    CurrentCourses(
      icon: 'assets/images/teacher.png',
      title: 'Faculty List',
        destination: MainScreen(),
    ),
    CurrentCourses(
      icon: 'assets/images/exam.png',
      title: 'Upload OMR',
        destination: MainScreen(),
    ),
    CurrentCourses(
      icon: 'assets/images/request.png',
      title: 'Request for Recheck',
        destination: MainScreen(),
    ),
  ];
}