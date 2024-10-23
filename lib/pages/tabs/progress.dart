import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/overall_progress.dart';
import 'package:trackitapp/pages/widgets/weekly_progres.dart';

class ProgressScreen extends StatelessWidget {
 final int totalPoints;
  final int totalPossiblePoints;

   const ProgressScreen({
    super.key,
    required this.totalPoints,
    required this.totalPossiblePoints,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weekly Progress")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:Column(
          children: [
            OverallProgress(),
            SizedBox(height: 13),
            WeeklyProgressGraph()
          ],
        ),
      ),
    );
  }
}
