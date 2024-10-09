// theme_provider.dart
import 'package:flutter/material.dart';
import 'package:trackit/color/colors.dart';

enum AppTheme { light, dark }

class ThemeProvider with ChangeNotifier {
  AppTheme _theme = AppTheme.light;

  // Define your color themes
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
        splashColor: Colors.black
        // Add any additional customization for dark theme
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
        ),
         cardColor: const Color.fromARGB(182, 158, 158, 158),
         canvasColor: Colors.black,
         hintColor: Colors.white,
         splashColor: Colors.black
        // Add any additional customization for light theme
      );
    }
  }

  void toggleTheme() {
    _theme = (_theme == AppTheme.light) ? AppTheme.dark : AppTheme.light;
    notifyListeners();
  }
}
