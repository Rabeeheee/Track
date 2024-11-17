import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/Habit/add_new_habit.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class HabitDetail extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? selectedAvatarPath;
  final String description;
  final int? habitId;

  const HabitDetail({
    super.key,
    required this.title,
    required this.subtitle,
    this.selectedAvatarPath,
    required this.description,
    required this.habitId,
  });

  Future<void> _deleteHabit(BuildContext context) async {
    final hiveService = HiveService();

    await hiveService.deleteHabit(habitId!);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Habit deleted successfully!"),
        backgroundColor: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Habit Details',
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewHabit(
                              habitId: habitId!,
                              title: title,
                              subtitle: subtitle,
                              selectedAvatarPath: selectedAvatarPath,
                              description: description,
                            )));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Habit'),
                      content:
                          const Text('Are you sure you want to delete this Habit?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Delete'))
                      ],
                    );
                  });

              if (shouldDelete == true) {
                // ignore: use_build_context_synchronously
                _deleteHabit(context);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 50,
                backgroundImage:
                    MemoryImage(base64Decode(selectedAvatarPath!))),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.themeData.splashColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.themeData.splashColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
