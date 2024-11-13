import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/utils/colors.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class SurveyOption extends StatelessWidget {
  final String emoji;
  final String text;
  final VoidCallback onTap; 

  SurveyOption({required this.emoji, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: onTap, 
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 16.0),
            ),
          
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0,color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
