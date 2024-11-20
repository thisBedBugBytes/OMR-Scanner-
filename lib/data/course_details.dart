import 'package:dashboard_ui/models/Current_courses.dart';
import 'package:flutter/material.dart';


import 'package:dashboard_ui/models/Current_courses.dart';

class CourseDetails {
  static final List<CurrentCourses> courses = const [
    CurrentCourses(
      icon: 'assets/images/grade_history1.png',
      title: 'Grade History',
    ),
    CurrentCourses(
      icon: 'assets/images/teacher.png',
      title: 'Faculty List',
    ),
    CurrentCourses(
      icon: 'assets/images/exam.png',
      title: 'Current Exam',
    ),
    CurrentCourses(
      icon: 'assets/images/request.png',
      title: 'Request for Recheck',
    ),
  ];
}