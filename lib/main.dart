
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackit/services/models/Hive_modals.dart';
import 'package:trackit/hive_service.dart';
import 'package:trackit/pages/tabs/habit_screen.dart';
import 'utils/theme_provider.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HiveService _hiveService = HiveService();
    Hive.registerAdapter(UserModelAdapter());
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


