// logout_dialog.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trackit/services/models/hive_service.dart';
import 'package:trackit/auth/splash_screen.dart';


showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Do you really want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                HiveService _hiveService = HiveService();
                await _hiveService.clearbox();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
