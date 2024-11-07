import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/providers/time_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/app_icon');
    final settings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);

    if (Platform.isAndroid && await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        'timer_alarm', 
        'Timer Alarm', 
        description: 'Channel for timer alarm notifications',
        importance: Importance.max,
      );
      await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  void _showAlarm() async {
    const androidDetails = AndroidNotificationDetails(
      'timer_alarm', 
      'Timer Alarm', 
      importance: Importance.max, 
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, 'Time’s up!', 'Your timer has ended.', notificationDetails);
  }

  void _openTimeDialog() {
    TextEditingController customTimeController = TextEditingController();
    bool _isInvalidInput = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Select Time Limit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(onPressed: () => _setTimeLimit(10), child: Text('10 minutes')),
                  TextButton(onPressed: () => _setTimeLimit(30), child: Text('30 minutes')),
                  TextButton(onPressed: () => _setTimeLimit(60), child: Text('1 hour')),
                  TextField(
                    controller: customTimeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter time between " 1-180 "',
                      errorText: _isInvalidInput ? 'Invalid input! Must be 1-180 minutes.' : null,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    int? minutes = int.tryParse(customTimeController.text);
                    if (minutes != null && minutes > 0 && minutes <= 180) {
                      _setTimeLimit(minutes);
                      Navigator.pop(context);
                    } else {
                      setDialogState(() {
                        _isInvalidInput = true;
                      });
                    }
                  },
                  child: Text('Set'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _setTimeLimit(int minutes) {
    Provider.of<TimerService>(context, listen: false).setTimeLimit(minutes);
  }

  void _restartTimer() {
    final timerService = Provider.of<TimerService>(context, listen: false);
    timerService.stopTimer(); 
    timerService.resetTimer(); 
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final timerService = Provider.of<TimerService>(context);
    double progress = timerService.remainingTime / (timerService.timeLimit * 60);

    return Scaffold(
      appBar: CustomAppBar(title: 'Focus Period'),
      body: Container(
        decoration: BoxDecoration(
          color: themeProvider.themeData.scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _openTimeDialog,
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 12.0,
                  percent: progress,
                  center: Text(
                    '${(timerService.remainingTime / 60).floor().toString().padLeft(2, '0')}:${(timerService.remainingTime % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: themeProvider.themeData.canvasColor),
                  ),
                  progressColor: const Color.fromARGB(255, 69, 69, 69),
                  backgroundColor: const Color.fromARGB(255, 139, 138, 138),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    timerService.startTimer(onTimerEnd: _showAlarm); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Icon(Icons.play_arrow, color: Colors.white),
                  label: Text('Start Timer', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    timerService.stopTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Icon(Icons.stop, color: Colors.white),
                  label: Text('Stop Timer', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: _restartTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Restart Timer', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
