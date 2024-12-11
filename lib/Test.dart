import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_v2/scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestUpload extends StatefulWidget {
  const TestUpload({super.key});

  @override
  State<TestUpload> createState() => _TestUploadState();
}

class _TestUploadState extends State<TestUpload> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MapEntry<String, String>> unmarked = [];

  Future <List<MapEntry<String, String>>> getPendingTests() async {
    try{
        User? user = _auth.currentUser;
        String? userId = user?.uid;
        print(userId);
        final student = await _firestore.collection('Student').doc(userId).get();

        if(student.exists){
          Map<String, dynamic>? data = student.data();
          print("Student data fetched successfully: $data");
          List<dynamic> tests = data?['Test'];
          print("im here!");
          for(var test in tests){
            var testId = test['testId'] as String;
            int? score = test['score'] as int;
            print("This is the $score");
            final Test = await _firestore.collection('Test').doc(testId).get();
            String name = Test.data()?['courseId'] as String;
            if(score == -1){

              unmarked.add(MapEntry(testId, name));
            }
          print(unmarked.length);


          }

        }
        return unmarked;
    } catch(e){

      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending tests'),
        backgroundColor: const Color(0xff6a3f7b),
      ),
      body: FutureBuilder<List<MapEntry<String, String>>>(
        future: getPendingTests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No admitted courses.'));
          }

          List<MapEntry<String, String>> tests = snapshot.data!;
          return ListView.builder(
            itemCount: tests.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text(
                    tests[index].value,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Status: Pending submission',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.document_scanner, color: Colors.white),
                    onPressed: () async {
                      Scanner scanner = Scanner(context);
                      await scanner.onPressed(tests[index].key);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

    );
  }
}
