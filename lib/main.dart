
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackit/hive_service.dart';
import 'package:trackit/screens/home/habit_screen.dart';
import 'theme_provider.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HiveService _hiveService = HiveService();
  Hive.initFlutter();
  Hive.openBox('userBox');
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


