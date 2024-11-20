import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer")),
      body: Center(
        child: Text("This is the Timer screen"),
      ),
    );
  }
}