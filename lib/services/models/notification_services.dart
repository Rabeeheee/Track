import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    // ignore: avoid_print
    print('notification with ID $id has beeen deleted');
  }

  Future<void> onSelectNotification(NotificationResponse response) async {
    if (response.payload != null) {
      // ignore: avoid_print
      print('Notification tapped! Payload: ${response.payload}');
    } else {
      // ignore: avoid_print
      print('Notification tapped without a payload!');
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int delay,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledTime = now.add(Duration(seconds: delay));

    // ignore: avoid_print
    print("Scheduling notification for: ${scheduledTime.toString()}");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          '2',
          'habit_channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    // ignore: unused_element
    Future<void> cancelNotification(int habitId) async {
      await flutterLocalNotificationsPlugin.cancel(habitId);
    }
  }
}
