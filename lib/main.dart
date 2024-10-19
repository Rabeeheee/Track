
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/auth/splash_screen.dart';
import 'package:trackitapp/pages/other/progressprovider.dart';
import 'package:trackitapp/pages/tabs/habit_screen.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/user_modal.dart';
import 'package:trackitapp/utils/login_manager.dart';
import 'utils/theme_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz; 
import 'package:timezone/timezone.dart' as tz; 


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); 
  await _initializeNotifications(); 


  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox('userBox');
  Hive.registerAdapter(AddhabitModalAdapter());
  await Hive.openBox<AddhabitModal>('habitBox');
  
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
      ],
      child: MyApp(),
    ),
  );
}

Future<void> _initializeNotifications() async {
 
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );
  
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
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
                return HabitScreen(name: '', quote: '', selectedAvatarPath: '',); 
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
