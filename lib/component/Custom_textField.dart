import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.icon,
    required this.controller,
  });
  final String title;
  final IconData icon;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white60),
      decoration: InputDecoration(
        suffixIcon: Icon(
          icon,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black, width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black, width: 2)),
        labelText: title,
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
