import 'dart:core';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_v2/request.dart';
import 'package:demo_v2/teacher_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [Radio].

class RadioExampleApp extends StatelessWidget {
  const RadioExampleApp({super.key});




  @override
  Widget build(BuildContext context) {
    return const RadioExample(questions: 0, test_id: null,);
  }
}

enum Choice { A, B, C, D, E }

class RadioExample extends StatefulWidget {
  final int questions;
  final test_id;

  const RadioExample({super.key, required this.questions, required this.test_id});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  List<Choice?> chosen = []; // List to store answers for each question
  List<int> ans = [];
  @override
  void initState() {
    super.initState();
    chosen = List.filled(widget.questions, Choice.E); // Initialize the list with null (no answer selected)
    ans = List.filled(widget.questions, -1);
  }

  List<Choice?> returnChosen(){
    List<Choice?> Chosen = chosen ?? [];
    return Chosen;
  }

  @override
  Widget build(BuildContext context) {
    int q = widget.questions;
    var testId = widget.test_id;
    print("this is the testId");
    print(testId);
    answerForm answerList = answerForm(q, testId);

    return MaterialApp(
      home: Scaffold(
      
        body: ListView.builder(
          itemCount: q, // q is the number of rows you want to create
          itemBuilder: (context, index) {
            int idx = index + 1 ;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
              <Widget>[
                Text('$idx.'),

                Flexible(
                  child: Transform.scale(
                    scale: 0.7,
                    child: ListTile(
                      title: Text('A'),
                      leading: Radio<Choice>(
                        value: Choice.A,
                        // Loop through choices if q > 4
                        groupValue: chosen[index],
                        onChanged: (Choice? value) {
                          setState(() {
                            chosen[index] = value;
                            ans[index] = 0;
                            print(answerList.key[chosen]);
                          });

                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Transform.scale(
                    scale: 0.7,
                    child: ListTile(
                      title: Text('B'),
                      leading: Radio<Choice>(
                        value: Choice.B,
                        // Loop through choices if q > 4
                        groupValue: chosen[index],
                        onChanged: (Choice? value) {
                          setState(() {
                            chosen[index] = value;
                            ans[index] = 1;
                          });

                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Transform.scale(
                    scale: 0.7,
                    child: ListTile(
                      title: Text('C'),
                      leading: Radio<Choice>(
                        value: Choice.C,
                        // Loop through choices if q > 4
                        groupValue: chosen[index],
                        onChanged: (Choice? value) {
                          setState(() {
                            chosen[index] = value;
                            ans[index] = 2;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Transform.scale(
                    scale: 0.7,
                    child: ListTile(
                      title: Text('D'),
                      leading: Radio<Choice>(
                        value: Choice.D,
                        // Loop through choices if q > 4
                        groupValue: chosen[index],
                        onChanged: (Choice? value) {
                          setState(() {
                            chosen[index] = value;
                            ans[index] = 3;
                            print(index);
                            print(ans[index]);
                          });
                        },
                      ),

                    ),
                  ),
                ),

              ],

            );
          },

        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.all(25.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              answerList.answers = ans;
              answerList.createForm(ans);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherDashboard()));

            },

            label: const Text("Store Answers"),
          ),
        ),
      
      ),
    );
  }
  }
class answerForm{
  int question;
  var test_id;
  answerForm(this.question, this.test_id);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<Choice, int> key = {Choice.A: 0, Choice.B: 1, Choice.C: 2, Choice.D: 3};
  List<int> answers = [];

  void createForm(List<int> answers) async{

    for(int i = 0; i < question; i++){
      print(answers[i]);
    }
      int pages = 1 + ((question - 56) / 60).ceil();
    int qStart, qEnd;

    for(int page = 0; page<pages; page++){
    //  _RadioExampleState radioExample =  _RadioExampleState();
      if (page == 0) {
        qStart = 0;
        qEnd = min(56, question);
      } else {
        qStart = 56 + (page - 1) * 60;
        qEnd = min(qStart + 60, question);
      }
      for(int i = qStart; i < qEnd; i++) {
        print("this is inside the createForm");
        print(page);
        print(answers[i]);
        if (test_id != null && answers[i] != -1) {
         await _firestore.collection('Test').doc(test_id).collection('Answer').doc(
              i.toString()).set({
            'Answer': answers[i],
            'Page': page
          });
        }
      }

    }

  }





}