import 'dart:typed_data';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';

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

    var url = Uri.parse('http://192.168.1.102:8000/pdf_generation/');
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
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        PermissionStatus status;
        if (androidInfo.version.sdkInt <= 32){
          status = await Permission.storage.request();

        } else {
          status = await Permission.photos.request();
        }
        if (status.isGranted) {
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
                          title: Text("File download"),
                          content: Text("You can view your test paper now"),
                          actions: [
                            TextButton(onPressed: () async {
                              var status = await getPermision();
                              if(status) {
                                //String filePath = await getFilePath();
                                filePath = await FileStorage.getExternalDocumentPath();
                                filePath += "/" + fileName + ".pdf";
                                print(filePath);
                                OpenFile.open(filePath);

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
    PermissionStatus status;
    if (androidInfo.version.sdkInt <= 32) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }
    return status.isGranted;
  }
  else return true;
}