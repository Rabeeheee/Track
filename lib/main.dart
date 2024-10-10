import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackit/auth/splash_screen.dart';
import 'package:trackit/pages/other/progressprovider.dart';
import 'package:trackit/services/models/Hive_modals.dart';
import 'utils/theme_provider.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Hive.initFlutter();
  

  Hive.registerAdapter(UserModelAdapter());
  
 
  await Hive.openBox('userBox');
  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
       ChangeNotifierProvider(create: (_)=> ThemeProvider())
      ],
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
      home: SplashScreen(),
    );
  }
}
