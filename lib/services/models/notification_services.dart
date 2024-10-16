import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initNotification() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    // Request notification permissions (important for Android 13+ and iOS)
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  // Notification select handler (used when a notification is tapped)
  Future<void> onSelectNotification(NotificationResponse response) async {
    // Handle the notification tap here
    if (response.payload != null) {
      print('Notification tapped! Payload: ${response.payload}');
    } else {
      print('Notification tapped without a payload!');
    }
  }

  // Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int delay, // delay in seconds
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledTime = now.add(Duration(seconds: delay));

    print("Scheduling notification for: ${scheduledTime.toString()}");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '2', // Create a notification channel in AndroidManifest
          'habit_channel', // Channel name
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
