import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:demo_v2/score.dart';
import 'package:demo_v2/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
Future<String> getTeacherEmail() async {
  User? user =  FirebaseAuth.instance.currentUser;
  return user?.email ?? '';  // Get the email of the logged-in user
}

class Scanner {

  final BuildContext context;

  Scanner(this.context);

  List<String> pictures = [];
  Future<void> onPressed() async {
    // Perform your scanning logic here


    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      sendImage sender = sendImage(pictures);
      var score = sender.getGrade();
      print("Scanned pictures: $pictures");
    } catch (exception) {
      print("Error during scanning: $exception");
    }
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => const TeacherDashboard())
    );
  }
}
saveTest sT = saveTest();
class sendImage {


  var test_id = sT.readAns();
  List<String> path;
  sendImage(this.path);
  var client = http.Client();
  Future <int>getGrade() async {
    try {
      var url = Uri.parse('http://192.168.1.102:8000/submitPaper/');
      var request = await http.MultipartRequest('POST', url);
      request.fields['test_id'] = await test_id;

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
    return 1;
  }



}




