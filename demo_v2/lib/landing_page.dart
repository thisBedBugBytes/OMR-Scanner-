import 'package:flutter/material.dart';
import 'package:demo_v2/signup_page.dart';
import 'login_page.dart';

class landing_page extends StatelessWidget {
  const landing_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffB81736),
              Color(0xff281537),
            ],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200.0),
              child: Image(image: AssetImage('assets/scan_logo.png')),
            ),
            const SizedBox(height: 20),  // Adding space between logo and title
            const Text(
              'OMR Exam Grader',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),  // Adding space between title and welcome text
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),  // Spacing between Welcome Back and buttons
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const login_page()));
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const signup_page()));
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Text "Continue with Google Account"
            const SizedBox(height: 12),
            // Elevated Button with Google icon
            Container(
              width: 250, // Adjust button width to make it more standard-sized
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add Google login logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Use backgroundColor instead of primary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: Image.asset(
                  'assets/google_logo.png',
                  width: 40, // Icon width
                  height: 40, // Icon height
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}