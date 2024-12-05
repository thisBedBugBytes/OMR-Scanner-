import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import

class FacultyListPage extends StatelessWidget {
  const FacultyListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty List'),
        backgroundColor: const Color(0xff6a3f7b),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Connect to the 'Faculties' collection in Firestore
        stream: FirebaseFirestore.instance.collection('Faculties').snapshots(),
        builder: (context, snapshot) {
          // Show loading indicator while data is being fetched
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there's an error in fetching the data
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading data!',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }

          // If no data is found in Firestore
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No faculties found!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Get the list of faculty documents from the snapshot
          final faculties = snapshot.data!.docs;

          // Create a ListView to display the faculty data
          return ListView.builder(
            itemCount: faculties.length,
            itemBuilder: (context, index) {
              final faculty = faculties[index];

              // Extract the 'Name' and 'Department' fields from the Firestore document
              final name = faculty['Name'] ?? 'No Name'; // Case-sensitive field: 'Name'
              final department = faculty['Department'] ?? 'No Department'; // Case-sensitive field: 'Department'

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(name), // Display the faculty's name
                  subtitle: Text(department), // Display the faculty's department
                ),
              );
            },
          );
        },
      ),
    );
  }
}