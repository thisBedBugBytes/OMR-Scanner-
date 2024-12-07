import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_v2/form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:uuid/uuid.dart';

class Grade extends StatefulWidget {
  const Grade({super.key});

  @override
  State<Grade> createState() => _GradeState();
}

class _GradeState extends State<Grade> {



  var success = false;
  String filePath = "";

  var client = http.Client();
  fetchData() async{
    var url = Uri.parse('http://192.168.1.102:8000/pdf_generation/');
    var response = await http.post(url);
    if(response.statusCode == 200){
      print("data fetched successfully;) ");
    }
    else{
      print("failfluttered to fetch the pdf.");
    }

  }
  //Uint8List base64Decode(String source) => base64.decode(source);
  Future<void> createData(String name, int q) async{

    var url = Uri.parse('http://172.20.113.225:8000/pdf_generation/');
    print(q);
    String filename = name + ".pdf";
    var response = await client.post(url,
        body: {'file_name': name, 'q_no': q.toString()});
    if(response.statusCode == 200){
      print(response.bodyBytes.length);


      FileStorage saveFile = await FileStorage();
      //String path = 'C:\\Temp\\birjis.pdf'; // Fixed path for saving the PDF
      if(Platform.isAndroid){
        // print("Im here");
       bool status = await getPermision();
        if (status) {
          var result = response.bodyBytes;
          FileStorage.writeCounter(result, filename);
          filePath = 'storage/emulated/0/Download/$filename';
          success = true;
          print("PDF downloaded successfully: }");

          print("PDF downloaded successfully: }");
        } else {
          // Handle permission denial
          print("Permission denied to access storage");

        }
      }
      else {
        // directory = Directory();

        var result = response.bodyBytes;
        FileStorage.writeCounter(result, filename);
        //final file = File(path);
        success = true;
        //await file.writeAsBytes(result);

        filePath  = await FileStorage.getExternalDocumentPath();
        print("PDF downloaded successfully: }");
      }
      // filePath += filename;
      //


    }
    else{
      print("failfluttered to fetch the pdf.");
    }
  }
  // Future<void>_openFile(String path) async{
  //   FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
  //     allowedFileExtensions: ['pdf'],
  //     allowedMimeTypes: ['application/pdf']
  //   );
  //
  //   final result = await FlutterDocumentPicker.openDocument(params: params);
  //
  // }
  bool scan = false;
  final TextEditingController fileNameController = TextEditingController();
  final TextEditingController questionNoController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fileNameController.dispose();
    questionNoController.dispose();
    super.dispose();
  } @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: fileNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a filename here',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: questionNoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the question number',
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                String fileName = fileNameController.text.trim();
                int questionNo = int.tryParse(questionNoController.text.trim()) ?? 0;

                if (fileName.isNotEmpty && questionNo > 0) {
                  createData(fileName, questionNo);


                  showDialog(
                      context: context, // Ensure you're passing the correct BuildContext
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("File download"),
                          content: const Text("You can view your test paper now"),
                          actions: [
                            TextButton(onPressed: () async {
                              var status = await getPermision();
                              if(status) {
                                //String filePath = await getFilePath();
                                filePath = await FileStorage.getExternalDocumentPath();
                                filePath += "/" + fileName + ".pdf";
                                print(filePath);
                                //OpenFile.open(filePath);
                                OpenFile.open(filePath).then((result){
                                  if(result.type == ResultType.done){
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => RadioExample(questions: questionNo, test_id: "123")));
                                  }
                                });


                              }
                              else{
                                openAppSettings();
                              }

                            }, child: const Text("Open")),
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            },
                                child: Text("Cancel"))
                          ],
                        );
                      });
                }
                else {
                  // Handle invalid input
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text("Please enter valid values."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(Uint8List bytes,String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file= File('$path/$name');;
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsBytes(bytes);
  }
}

Future<bool> getPermision()async {
  if(Platform.isAndroid) {
    // print("Im here");
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    bool status = true;
    if (androidInfo.version.sdkInt <= 32) {
    if(await Permission.storage.request().isGranted){
      status = true;
    }
    else if(await Permission.storage.request().isDenied){
      status = false;
    }
    else if(await Permission.storage.request().isPermanentlyDenied){
      status = false;
    }
    }
    else{
      status = true;
    }
    return status;
  }
  else return true;
}
//for storing the test info.
//evertime a test is created, the test id should be availabe to the student collection/entity
//in some way, so that the student can upload image for that specific test
// class Tests{
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   var teacherId;
//   var sectionId;
//   Tests() {
//
//     User? user = _auth.currentUser;
//     teacherId = user!.uid;
//     var query = _firestore.collection('Section').where("teacher_id", "==", teacherId);
//
//   }
//   Uuid uuid = Uuid();
//   var testId;
//
//
//   Future<void> setTest(var test_id)async {
//     await _firestore.collection('Test').doc(test_id).set({
//       'sectionId': '',
//       'teacherId': teacherId, //need from the _auth
//       'courseId': ''
//     });
//     await _firestore.collection('Test').doc(test_id).collection('Answer').doc('temp').set(
//         {
//           'status': 'null'
//         });
//     await _firestore.collection('Test').doc(testId).collection('Answer').doc('temp').delete;
//
//     }
//   }
//
//
//
//
//}