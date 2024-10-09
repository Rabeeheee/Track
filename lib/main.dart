
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit/screens/home/habit_screen.dart';
import 'theme_provider.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Theme Example',
      theme: themeProvider.themeData,
      home: HabitScreen(),
    );
  }
}


