import 'package:flutter/material.dart';

import '../constants_colors.dart';
import '../services/client_http.dart';
import 'text_labels.dart';

class Layout extends StatelessWidget {
  String title;
  Widget body;
  Layout({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    clearToken() async {
      ClientHttp(
        baseUrl: '',
      ).clearToken();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorsDefaults.background,
        title: buildTexTitle(title),
        actions: [
          Visibility(
            visible: title != 'Crie sua conta',
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => clearToken(),
            ),
          )],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: body,
    );
  }
}
