import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackit/auth/Login.dart';
import 'package:trackit/auth/splash_screen.dart';
import 'package:trackit/pages/other/progressprovider.dart';
import 'package:trackit/pages/tabs/habit_screen.dart';
import 'package:trackit/services/models/Hive_modals.dart';
import 'package:trackit/utils/login_manager.dart';
import 'utils/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox('userBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Theme Provider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedBuilder(
      animation: themeProvider, 
      builder: (context, _) {
        return MaterialApp(
          home: FutureBuilder(
            future: LoginManager.getLoginStatus(),
            builder: (context, snapshot) {
             if (snapshot.hasData && snapshot.data == true) {
                return HabitScreen(); 
              } else {
                return SplashScreen(); 
              }
            },
          ),
          theme: themeProvider.themeData,
        );
      },
    );
  }
}
