import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_truck/routes/routes.dart';

import '../services/login_service.dart';

class LoginProvider extends GetxController {
  AuthService authController = Get.find<AuthService>();
  RxBool isLogin = false.obs;
  RxInt _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Future<void> login() async {
    isLogin.value = true;
    if(formKey.currentState!.validate()){
      String email = emailController.text;
      String password = passwordController.text;
      authController.login(email, password);
      isLogin.value = false;
    }else {
      isLogin.value = false;
    }
  }

  void goToCreateUser() {
    Get.toNamed(Routes.register);
  }

  void onItemTappedMenuBar(int index) {
    _selectedIndex.value = index;
  }

}
