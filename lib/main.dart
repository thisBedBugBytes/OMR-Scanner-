import 'package:demo_v2/form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'landing_page.dart';
import 'signup_page.dart';
import 'forgot_password.dart';
import 'login_page.dart';  // Import LoginPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home: const LandingPage(),
      routes: {
        '/signup': (context) => const SignupPage(),
        '/forgot_password': (context) => const ForgotPassword(),
        '/login': (context) => const LoginPage(),  // Add LoginPage route here
      },
    );
  }
}
