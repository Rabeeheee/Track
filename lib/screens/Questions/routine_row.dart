import 'package:flutter/material.dart';

class HabitRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  HabitRow({required this.icon, required this.label, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 15),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: iconColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Fonts',
          ),
        ),
      ],
    );
  }
}
