import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final List<int> responses;

  ResultPage({required this.responses});

  @override
  Widget build(BuildContext context) {
    // Calculate the total points
    int totalPoints = responses.reduce((a, b) => a + b);

    // Generate a rating based on total points
    String rating;
    if (totalPoints >= 30) {
      rating = 'Excellent';
    } else if (totalPoints >= 20) {
      rating = 'Good';
    } else if (totalPoints >= 10) {
      rating = 'Average';
    } else {
      rating = 'Needs Improvement';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Survey Results')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Total Points: $totalPoints',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Your Rating: $rating',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
             
            ],
          ),
        ),
      ),
    );
  }
}
