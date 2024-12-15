import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:health_truck/routes/routes.dart';

class LoginProvider extends ChangeNotifier {
  bool isLogin = false;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  void login() {
    isLogin = true;
    Get.toNamed(Routes.home);
    if(formKey.currentState!.validate()){
      String email = emailController.text;
      String password = passwordController.text;
      print('Email: $email, Password: $password');

    }
    notifyListeners();
  }

  void goToCreateUser() {
    Get.toNamed(Routes.register);
  }

  void onItemTappedMenuBar(int index) {
    _selectedIndex = index;
  }

  void logout() {
    isLogin = false;
    if (Platform.isAndroid){
      SystemNavigator.pop();
    }else if (Platform.isIOS){
      exit(0);
    }
    notifyListeners();
  }
}
