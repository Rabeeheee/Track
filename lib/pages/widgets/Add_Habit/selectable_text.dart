import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class SelectableTextWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableTextWidget({super.key, 
  required this.text, 
  required this.isSelected, 
  required this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: isSelected ? Colors.blue : themeProvider.themeData.splashColor,
          
        ),
      ),
    );
  }
}
