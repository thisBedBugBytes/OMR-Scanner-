import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_v2/request.dart';
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

  @override
  void initState() {
    super.initState();
    chosen = List.filled(widget.questions, Choice.E); // Initialize the list with null (no answer selected)
  }

  List<Choice?> returnChosen(){
    List<Choice?> Chosen = chosen ?? [];
    return Chosen;
  }

  @override
  Widget build(BuildContext context) {
    int q = widget.questions;
    var testId = widget.test_id;

    answerForm answerList = answerForm(q, testId);
    answerList.answers = List.filled(q, -1);
    return MaterialApp(
      home: Scaffold(
      
        body: ListView.builder(
          itemCount: q, // q is the number of rows you want to create
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                Flexible(
                  child: ListTile(
                    title: Text('A'),
                    leading: Radio<Choice>(
                      value: Choice.A,
                      // Loop through choices if q > 4
                      groupValue: chosen[index],
                      onChanged: (Choice? value) {
                        setState(() {
                          chosen[index] = value;
                          answerList.answers[index] = answerList.key[chosen] ?? -1;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text('B'),
                    leading: Radio<Choice>(
                      value: Choice.B,
                      // Loop through choices if q > 4
                      groupValue: chosen[index],
                      onChanged: (Choice? value) {
                        setState(() {
                          chosen[index] = value;
                          answerList.answers[index] = answerList.key[chosen] ?? -1;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text('C'),
                    leading: Radio<Choice>(
                      value: Choice.C,
                      // Loop through choices if q > 4
                      groupValue: chosen[index],
                      onChanged: (Choice? value) {
                        setState(() {
                          chosen[index] = value;
                          answerList.answers[index] = answerList.key[chosen] ?? -1;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: ListTile(
                    title: Text('D'),
                    leading: Radio<Choice>(
                      value: Choice.D,
                      // Loop through choices if q > 4
                      groupValue: chosen[index],
                      onChanged: (Choice? value) {
                        setState(() {
                          chosen[index] = value;
                          answerList.answers[index] = answerList.key[chosen] ?? -1;
                        });
                      },
                    ),
                  ),
                ),
      
              ],
            );
          },
          prototypeItem: ElevatedButton(onPressed: () {
            answerList.createForm();
          }, child: const Text("Store answers"),)
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

  void createForm() async{

    int page = 0;

    for(int i = 0; i<question; i++){
    //  _RadioExampleState radioExample =  _RadioExampleState();

      if( (i+4) % 60 == 0) {
        page += 1;
      }
      if(test_id != null && answers[i] != -1){
        _firestore.collection('Test').doc(test_id).collection('Answer').doc(i.toString()).set({
          'answer': answers[i],
          'page' : page
        });
      }

    }

  }





}