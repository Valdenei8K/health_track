import 'package:flutter/material.dart';

import '../constants_colors.dart';
import 'text_labels.dart';

class Layout extends StatelessWidget {
  String title;
  Widget body;
  Layout({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorsDefaults.background,
        title: buildTexTitle(title),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: body,
    );
  }
}
