import 'package:flutter/material.dart';

class Customedtextfiel extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final InputDecoration? decoration;

  const Customedtextfiel({
    super.key,
    required this.obscureText,
    required this.controller,
    required this.text,
    this.validator,
    this.suffixIcon,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      decoration: decoration?.copyWith(
        hintText: text,
        suffixIcon: suffixIcon,
      ) ??
          InputDecoration(
            hintText: text,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(),
          ),
    );
  }
}