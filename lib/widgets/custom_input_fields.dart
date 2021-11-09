import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  CustomTextFormField(
      {required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: ((_vlaue) => onSaved(_vlaue!)),
      cursorColor: const Color.fromRGBO(255, 255, 255, 1),
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (_value) {
        return RegExp(regEx).hasMatch(_value!) ? null : "Enter a valid value.";
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }
}
