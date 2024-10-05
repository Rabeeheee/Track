import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, double> ratings;

  ResultScreen({required this.ratings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Your Ratings'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Rating: ${ratings['overallRating']?.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Wisdom Rating: ${ratings['wisdomRating']?.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Strength Rating: ${ratings['strengthRating']?.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Focus Rating: ${ratings['focusRating']?.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Confidence Rating: ${ratings['confidenceRating']?.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Discipline Rating: ${ratings['disciplineRating']?.toStringAsFixed(2)}%',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
