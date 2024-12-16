import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarApp {

  static success(
    String message,
  ) {
    return Get.snackbar(
      'Sucesso',
      message,
      colorText: Colors.white,
      backgroundColor: Colors.greenAccent.shade700,
      icon: const Icon(Icons.add_alert),
    );
  }

  static error(
      String message,
      ) {
    return Get.snackbar(
      'Erro',
      message,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent.shade100,
      icon: const Icon(Icons.add_alert),
    );
  }

  static Info(
      String message,
      ) {
    return Get.snackbar(
      'Informação',
      message,
      colorText: Colors.white,
      backgroundColor: Colors.blueAccent.shade200,
      icon: const Icon(Icons.add_alert),
    );
  }

}