import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/theme_model.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isTeacher = true; // Initial state is Teacher

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(isTeacher ? Icons.person : Icons.groups),
                onPressed: () {
                  setState(() {
                    isTeacher = !isTeacher;
                  });
                },
                tooltip: isTeacher ? "Switch to Student" : "Switch to Teacher",
              ),
              IconButton(
                icon: Icon(
                  themeProvider.isDark ? Icons.nights_stay : Icons.wb_sunny,
                  color: themeProvider.isDark ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  themeProvider.isDark = !themeProvider.isDark;
                },
              ),
            ],
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: themeProvider.isDark
                ? [
                    const Color(0xff800000), // Maroon
                    const Color(0xffFF0000), // Red
                  ]
                : [
                    Colors.red[900]!,
                    Colors.red[800]!,
                    Colors.red[400]!,
                  ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    isTeacher ? "Teacher" : "Student",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeProvider.isDark
                        ? const Color(0xff2F2F2F)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            color: themeProvider.isDark
                                ? const Color(0xff2F2F2F)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.isDark
                                    ? Colors.black.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200]!,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Email or User Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 35),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 35),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: themeProvider.isDark
                                ? const Color(0xff800000)
                                : Colors.red[900],
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          "Continue with",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue,
                                ),
                                child: Center(
                                  child: Text(
                                    "Google Account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30),
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Text(
                                    "GitHub Account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}