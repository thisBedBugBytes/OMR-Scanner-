import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:dashboard_ui/screens/main_screen.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';


class Scanner {

  final BuildContext context;

  Scanner(this.context);

  List<String> pictures = [];
  Future<void> onPressed() async {
    // Perform your scanning logic here

    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      print("Scanned pictures: $pictures");
    } catch (exception) {
      print("Error during scanning: $exception");
    }
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => const MainScreen())
    );
  }
}





