import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final bool isSelected;

  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Fonts',
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 2,
          width: 50,
          color: isSelected ? Colors.blue : Colors.white,
        ),
      ],
    );
  }
}
