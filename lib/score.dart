import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Grades'),
        ),
        body: const Center(
          child: Text('Please log in to view your grades.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc('Student Score')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No scores available.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['Email'] != user.email) {
            return const Center(child: Text('No scores available for this user.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Colors.grey[900],
                child: ListTile(
                  title: Text(
                    'Score: ${data['Score']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}