import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:demo_v2/student_dashboard.dart';
import 'package:demo_v2/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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
  Future <int>getGrade() async {
    try {
      var url = Uri.parse('http://172.20.113.225:8000/submitPaper/');
      var request = await http.MultipartRequest('POST', url);

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




