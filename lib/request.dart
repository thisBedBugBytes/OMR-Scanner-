import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class request extends StatelessWidget {
  const request({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Request for Recheck'),
        backgroundColor: const Color(0xff6a3f7b),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('User')
            .doc('Teacher') // Fetching the specific 'Teacher' document
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'No teacher data available.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          // Extracting fields from the Teacher document
          final teacherData = snapshot.data!.data() as Map<String, dynamic>;
          final name = teacherData['Name'] as String? ?? 'Unknown';
          final email = teacherData['Email'] as String? ?? 'No email';
          final course = teacherData['Course'] as String? ?? 'No course';

          return Center(
            child: Card(
              color: Colors.grey[900],
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: ListTile(
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  'Course: $course\nEmail: $email',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}