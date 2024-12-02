import 'package:dashboard_ui/models/Current_courses.dart';
import 'package:dashboard_ui/widgets/pdf_screen.dart';
import 'package:flutter/material.dart';


import 'package:dashboard_ui/models/Current_courses.dart';

import '../screens/main_screen.dart';
import '../util/create_pdf.dart';

class CourseDetails {
  static List<CurrentCourses> courses = [
    CurrentCourses(
      icon: 'assets/images/grade_history1.png',
      title: 'Exam History',
      destination: MainScreen(),
    ),
     CurrentCourses(
      icon: 'assets/images/teacher.png',
      title: 'Section List',
      destination: MainScreen(),
    ),
     CurrentCourses(
      icon: 'assets/images/exam.png',
      title: 'Current Exam',
       destination: MainScreen(),
    ),
     const CurrentCourses(
      icon: 'assets/images/request.png',
      title: 'Create Test',
       destination: Grade(),
    ),
  ];
}