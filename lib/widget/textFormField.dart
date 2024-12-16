import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_truck/constants_colors.dart';

dynamic validField(String? value) {
  String v = value.toString().trim();
  if (v.isEmpty) {
    return "O Campo não pode ser vazio";
  }
  return null;
}

Widget textForm({
  required TextEditingController controller,
  required TextInputType textInputType,
  required bool obscureText,
  Iterable<String>? autofillHints,
  Function(String? value)? validator,
  Widget? suffixIcon,
  TextInputAction? textInputAction,
  Icon? prefixIcon,
  bool ignoreReg = false,
  int? maxLength,
  FocusNode? focusNode,
  Function(String)? onChanged,
  String hintText = "",
}) {
  return TextFormField(
    focusNode: focusNode,
    inputFormatters:
        ignoreReg ? null : [FilteringTextInputFormatter.deny(RegExp(" "))],
    enableSuggestions: false,
    obscureText: obscureText,
    textInputAction: textInputAction,
    maxLength: maxLength,
    decoration: InputDecoration(
      errorStyle: const TextStyle(color: Colors.red),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      counterText: "",
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: ColorsDefaults.background,
        ),
      ),
    ),
    style: TextStyle(color: ColorsDefaults.background),
    controller: controller,
    keyboardType: textInputType,
    validator: (value) =>
        validator != null ? validator(value) : validField(value),
    onChanged: onChanged,
    autofillHints: autofillHints,
  );
}

Container buildTextField(
    {required TextEditingController controller,
    required Function onChanged,
    TextInputType keyboardType = TextInputType.number,
    String? hintText,
    Widget? prefixIcon,
    int length = 6}) {
  return Container(
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: length,
      onChanged: (value) => onChanged(value),
      style: TextStyle(color: ColorsDefaults.background),
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon,
        counterText: "",
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: ColorsDefaults.background,
          ),
        ),
      ),
      inputFormatters: [LengthLimitingTextInputFormatter(length)],
    ),
  );
}
