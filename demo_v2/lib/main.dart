import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'landing_page.dart';

import 'signup_page.dart';
import 'forgot_password.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home:const LandingPage(),
      routes: {
        '/signup': (context) => const SignupPage(),
        '/forgot_password': (context) => const ForgotPassword(),
      },
    );
  }
}