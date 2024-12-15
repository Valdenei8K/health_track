import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String textHelper = "",
}) {
  return TextFormField(
    focusNode: focusNode,
    inputFormatters: ignoreReg? null:[FilteringTextInputFormatter.deny(RegExp(" "))],
    enableSuggestions: false,
    obscureText: obscureText,
    textInputAction: textInputAction,
    maxLength: maxLength,
    decoration: InputDecoration(
      errorStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      counterText: "",
      helperText: textHelper,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
    style: TextStyle(color: Colors.black),
    controller: controller,
    keyboardType: textInputType,
    validator: (value) => validator != null ? validator(value) : validField(value),
    onChanged: onChanged,
    autofillHints: autofillHints,
  );
}