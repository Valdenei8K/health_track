import 'package:flutter/material.dart';
import 'package:health_truck/constants_colors.dart';

Padding buildText(String title) {
  return Padding(
    padding: EdgeInsets.only(top: 10, bottom: 5),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ColorsDefaults.background,
      ),
    ),
  );
}

Text buildTexTitle(String title){
  return Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );
}