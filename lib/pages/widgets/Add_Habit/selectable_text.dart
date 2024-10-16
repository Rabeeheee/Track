import 'package:flutter/material.dart';

class SelectableTextWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  SelectableTextWidget({required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: isSelected ? Colors.blue : Colors.black,
          decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}
