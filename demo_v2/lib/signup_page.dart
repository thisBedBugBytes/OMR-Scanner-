import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Role selection
  bool _isTeacher = false;
  bool _isStudent = false;

  // Sign-up function
  Future<void> _signUp() async {
    try {
      // Check if a role is selected
      if (!_isTeacher && !_isStudent) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select a role: Teacher or Student'),
        ));
        return;
      }

      // Validate email input based on role
      String email = _emailController.text.trim();
      if (_isTeacher) {
        // Ensure the email contains only alphabets and ends with @gmail.com
        if (!RegExp(r'^[a-zA-Z]+@gmail\.com$').hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Teacher email must contain only alphabets and end with @gmail.com'),
          ));
          return;
        }
      } else if (_isStudent) {
        // Ensure the email contains only numbers and ends with @gmail.com
        if (!RegExp(r'^[0-9]+@gmail\.com$').hasMatch(email)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Student email must contain only numbers and end with @gmail.com'),
          ));
          return;
        }
      }

      // Check if the passwords match
      if (_passwordController.text != _repeatPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Passwords do not match'),
        ));
        return;
      }

      // Sign up the user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      // Get the user
      User? user = userCredential.user;

      if (user != null) {
        // Optionally, update the display name of the user
        await user.updateDisplayName(_nameController.text);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User created successfully'),
        ));

        // Navigate to the login page after sign-up
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on FirebaseAuthException catch (e) {
      // Handle any errors and display error messages
      print('Error: ${e.message}'); // Print error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'An error occurred'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xffB81736),
                  Color(0xff281537),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Name TextField
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    // Email TextField
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    // Password TextField
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                        label: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    // Repeat Password TextField
                    TextField(
                      controller: _repeatPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                        label: Text(
                          'Repeat Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffB81736),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Role Selection Checkboxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _isTeacher,
                          onChanged: (value) {
                            setState(() {
                              _isTeacher = value!;
                              if (_isTeacher) _isStudent = false; // Deselect student
                            });
                          },
                        ),
                        const Text('Teacher'),
                        Checkbox(
                          value: _isStudent,
                          onChanged: (value) {
                            setState(() {
                              _isStudent = value!;
                              if (_isStudent) _isTeacher = false; // Deselect teacher
                            });
                          },
                        ),
                        const Text('Student'),
                      ],
                    ),
                    const SizedBox(height: 80),
                    // SignUp Button
                    GestureDetector(
                      onTap: _signUp, // Call the sign-up method when the user taps the button
                      child: Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xffB81736),
                              Color(0xff281537),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Navigate to Login Page if the user already has an account
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Already have an account? Sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
