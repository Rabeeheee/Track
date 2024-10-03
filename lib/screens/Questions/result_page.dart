import 'package:flutter/material.dart';
import 'package:trackit/color/colors.dart';

class ResultScreen extends StatelessWidget {
  final double overallRating;
  final double wisdomRating;
  final double strengthRating;
  final double focusRating;
  final double confidenceRating;
  final double disciplineRating;

  ResultScreen({
    required this.overallRating,
    required this.wisdomRating,
    required this.strengthRating,
    required this.focusRating,
    required this.confidenceRating,
    required this.disciplineRating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Results")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overall Rating: ${overallRating.toStringAsFixed(2)}%'),
            SizedBox(height: 10),
            Text('Wisdom Rating: ${wisdomRating.toStringAsFixed(2)} / 5'),
            SizedBox(height: 10),
            Text('Strength Rating: ${strengthRating.toStringAsFixed(2)} / 5'),
            SizedBox(height: 10),
            Text('Focus Rating: ${focusRating.toStringAsFixed(2)} / 5'),
            SizedBox(height: 10),
            Text('Confidence Rating: ${confidenceRating.toStringAsFixed(2)} / 5'),
            SizedBox(height: 10),
            Text('Discipline Rating: ${disciplineRating.toStringAsFixed(2)} / 5'),
          ],
        ),
      ),
    );
  }
}
