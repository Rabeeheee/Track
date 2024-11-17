import 'package:flutter/material.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/auth/splash_screen.dart';
import 'package:trackitapp/utils/login_manager.dart';

showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Do you really want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () async {
              // ignore: no_leading_underscores_for_local_identifiers
              HiveService _hiveService = HiveService();
              await _hiveService.clearUserBox();
              await _hiveService.clearHabitBox();
              await LoginManager.clearLoginStatus();
              await _hiveService.clearTaskBox();
              await _hiveService.clearDiaryBox();
              await _hiveService.clearFolderBox();

              Navigator.pushAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text(
              'Restart',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
