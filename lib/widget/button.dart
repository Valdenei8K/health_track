import 'package:flutter/material.dart';

import '../constants_colors.dart';

Widget buttonElevated({
  required String text,
  Function()? onPressed,
}) {
  return ElevatedButton(
    style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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

Widget customElevatedButton({
  required BuildContext context,
  required String text,
  required Function onPress,
  borderRadius = 16.0,
  onLoad = false,
  disabled = false,
  double? elevation,
  IconData? icon,
}) {
  return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(ColorsDefaults.background),
          elevation:
              elevation != null ? WidgetStateProperty.all(elevation) : null,
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ))),
      onPressed: disabled || onLoad ? null : () => onPress(),
      child: onLoad
          ? SizedBox(
              height: 20,
              width: 20,
              child: const CircularProgressIndicator(color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null ? Icon(icon, size: 17) : const SizedBox(),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ));
}
