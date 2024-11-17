import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackitapp/utils/colors.dart';

enum AppTheme { light, dark }

class ThemeProvider with ChangeNotifier {
  AppTheme _theme;

  ThemeProvider(this._theme);

  AppTheme get theme => _theme;

  ThemeData get themeData => _getThemeData();

  ThemeData _getThemeData() {
    if (_theme == AppTheme.dark) {
      return ThemeData.dark().copyWith(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        cardColor: const Color.fromARGB(255, 35, 35, 35),
        canvasColor: Colors.white,
        splashColor: const Color.fromARGB(255, 255, 255, 255),
        hoverColor: AppColors.primaryColor,
        focusColor: Colors.black,
        shadowColor: const Color.fromARGB(255, 86, 86, 86),
        dividerColor: Colors.white,
        hintColor: const Color.fromARGB(255, 56, 56, 56),
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
        cardColor: Colors.blueGrey[100],
        canvasColor: Colors.black,
        splashColor: Colors.black,
        hoverColor: Colors.white,
        focusColor: Colors.white,
        dividerColor: Colors.black,
        shadowColor: Colors.white,
        hintColor: const Color.fromARGB(255, 202, 201, 201),
      );
    }
  }

  void toggleTheme() async {
    _theme = (_theme == AppTheme.light) ? AppTheme.dark : AppTheme.light;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _theme == AppTheme.dark);
  }

  static Future<ThemeProvider> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    return ThemeProvider(isDarkTheme ? AppTheme.dark : AppTheme.light);
  }
}
