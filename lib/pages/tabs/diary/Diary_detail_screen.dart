
// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/diary_model.dart';
import 'package:trackitapp/pages/tabs/diary/add_diary_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class DiaryDetailScreen extends StatelessWidget {
  final Diary diary;

  // ignore: use_key_in_widget_constructors
  const DiaryDetailScreen({required this.diary});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,
              color: themeProvider.themeData.splashColor),
        ),
        title: diary.title,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: themeProvider.themeData.splashColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddDiaryScreen(date: diary.date, diary: diary),
                ),
              );
            },
          ),
          IconButton(
            icon:
                Icon(Icons.delete, color: themeProvider.themeData.splashColor),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        color: themeProvider.themeData.scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (diary.selectedImagePath != null) ...[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(diary.selectedImagePath!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              "Date: ${diary.date.toLocal().toString().split(' ')[0]}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.splashColor,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: themeProvider.themeData.cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    diary.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Diary Entry"),
          content: const Text("Are you sure you want to delete this diary entry?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final diaryBox = await Hive.openBox<Diary>('diarybox');
                await diaryBox.delete(diary.id);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Diary entry deleted successfully")),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
