import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:demo_v2/student_dashboard.dart';
import 'package:demo_v2/teacher_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Scanner {

  final BuildContext context;

  Scanner(this.context);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  List<String> pictures = [];
  int score = -1;
  Future<void> onPressed(String testId) async {

    List<dynamic> tests = [];

    User? user = _auth.currentUser;
    var uid = user?.uid;
    final student = await _firestore.collection('Student').doc(uid).get();
    if(student.exists) {
      var data = student.data();
      tests = data?['Test'] ?? [];

      }



    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      sendImage sender = sendImage(pictures);
      score = await sender.getGrade(testId);
      if(score != -1){
        List<dynamic> updated = tests.map((test) {
          if(test['testId'] == testId) {
            return {
              'testId': testId,
              'score': score
            };
          }
          return test;
        }).toList();
        _firestore.collection('Student').doc(uid).update({
          'Test': updated
        });
      }else{
        print("There was an issue");
      }

      print("Scanned pictures: $pictures");
    } catch (exception) {
      print("Error during scanning: $exception");
    }
    // Navigator.push(context,
    // MaterialPageRoute(builder: (context) => const StudentDashboard())
    // );
    Navigator.pop(context);
  }
}
class sendImage {
  List<String> path;
  sendImage(this.path);
  var client = http.Client();
  Future <int>getGrade(String testId) async {
    try {
      var url = Uri.parse('http://192.168.1.102:8000/submitPaper/');
      var request = await http.MultipartRequest('POST', url);
      request.fields['testId'] = testId;
      print(testId);
      for(var image in path){
        request.files.add(await http.MultipartFile.fromPath('images', image));
      }
      var response = await request.send();
    if(response.statusCode == 200){
      var responseData = await http.Response.fromStream(response);
      var data = json.decode(responseData.body);
      print(data['score']);
      return data['score'];
    }
    } finally {
      client.close();
    }
    return -1;
  }



}




