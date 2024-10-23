import 'package:flutter/material.dart';

class MySelectionButton extends StatelessWidget {
  const MySelectionButton({
    super.key,
    required this.title,
    required this.onTap,
    this.minWidth,
  });

  final VoidCallback onTap;
  final String title;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: minWidth,
      onPressed: onTap,
      color: Colors.deepPurpleAccent,
      textColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
