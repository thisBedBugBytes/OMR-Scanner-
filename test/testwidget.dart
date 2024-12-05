import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_v2/score.dart';  // Ensure to import your ScoreService

class TestWidget extends StatelessWidget {
  final ScoreService scoreService = ScoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Score Service')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _testSaveScannedScore();
          },
          child: Text('Save Scanned Score'),
        ),
      ),
    );
  }

  void _testSaveScannedScore() async {
    try {
      await scoreService.saveScannedScore(
        email: 'testuser@example.com',  // Mock email
        course: 'Math 101',             // Mock course
        name: 'John Doe',               // Mock student name
        scannedScore: 95,               // Mock scanned score
      );
      print("Test score saved successfully!");
    } catch (e) {
      print("Error during test: $e");
    }
  }
}