import 'package:dashboard_ui/util/create_pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'header_widget.dart';

class PdfScreen  extends StatelessWidget {
  const PdfScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [

              Grade()
            ],
          ),
        )
    );
  }
}
