import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  const MyInputField({
    super.key,
    this.onChanged,
    this.label,
  });
  final Function(String)? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.deepPurple[50],
      ),
    );
  }
}
