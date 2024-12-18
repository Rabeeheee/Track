import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/auth/splash_screen.dart';
import 'package:trackitapp/pages/other/progressprovider.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/calender_modal.dart';
import 'package:trackitapp/services/models/diary_model.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/services/models/memory_model.dart';
import 'package:trackitapp/services/models/progress_modal.dart';
import 'package:trackitapp/services/models/user_modal.dart';
import 'package:trackitapp/services/providers/time_service.dart';
import 'package:trackitapp/utils/login_manager.dart';
import 'utils/theme_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await _initializeNotifications();

  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox('userBox');
  Hive.registerAdapter(AddhabitModalAdapter());
  await Hive.openBox<AddhabitModal>('habitBox');
  Hive.registerAdapter(WeeklyProgressAdapter());
  await Hive.openBox<WeeklyProgress>('weeklyProgressBox');
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(DiaryAdapter());
  Hive.registerAdapter(FolderAdapter());

  final themeProvider = await ThemeProvider.loadTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => themeProvider),
        Provider<HiveService>(create: (_) => HiveService()),
        ChangeNotifierProvider(create: (_) => TimerService()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // ignore: prefer_const_declarations
  final InitializationSettings initializationSettings = const InitializationSettings(
    android: androidInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

void initializeTimeZones() {
  tz.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedTheme(
      data: themeProvider.themeData,
      duration: const Duration(seconds: 5),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: LoginManager.getLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return const BottomNav();
            } else {
              return const SplashScreen();
            }
          },
        ),
        theme: themeProvider.themeData,
        debugShowMaterialGrid: false,
      ),
    );
  }
}
