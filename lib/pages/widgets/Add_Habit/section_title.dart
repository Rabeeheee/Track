import 'package:flutter/material.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final bool isSelected;

  const SectionTitleWidget({
    Key? key,
    required this.title,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Fonts',
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 2,
          width: 50,
          color: isSelected ? Colors.blue : Colors.transparent, // Blue underline when selected
        ),
      ],
    );
  }
}
