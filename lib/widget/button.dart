import 'package:flutter/material.dart';

Widget buttonElevated({
  required String text,
  Function()? onPressed,
}) {
  return ElevatedButton(
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.white54)))),
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    ),
  );
}
