import 'package:flutter/material.dart';
import 'package:trackit/utils/colors.dart';

enum AppTheme { light, dark }

class ThemeProvider with ChangeNotifier {
  AppTheme _theme = AppTheme.light;

  final Color lightPrimaryColor = Colors.blue;
  final Color darkPrimaryColor = Colors.deepPurple;

  ThemeData get themeData => _getThemeData();

  ThemeData _getThemeData() {
    if (_theme == AppTheme.dark) {
      return ThemeData.dark().copyWith(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
        cardColor: Colors.white,
        canvasColor: Colors.white,
        splashColor: Colors.black,
        hoverColor: AppColors.primaryColor,
        focusColor: Colors.black,
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
        ),
        cardColor: Color.fromARGB(255, 235, 235, 235),
        canvasColor: Colors.black,
        hintColor: Colors.white,
        splashColor: Colors.black,
        hoverColor: Colors.white,
        focusColor: Colors.white,
      );
    }
  }

  void toggleTheme() {
    _theme = (_theme == AppTheme.light) ? AppTheme.dark : AppTheme.light;
    notifyListeners(); 
  }
}
