import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, double> ratings;

  const ResultScreen({Key? key, required this.ratings, required String habitResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingRow('Overall Rating', ratings['overallRating'] ?? 0),
            _buildRatingRow('Wisdom Rating', ratings['wisdomRating'] ?? 0),
            _buildRatingRow('Strength Rating', ratings['strengthRating'] ?? 0),
            _buildRatingRow('Focus Rating', ratings['focusRating'] ?? 0),
            _buildRatingRow('Confidence Rating', ratings['confidenceRating'] ?? 0),
            _buildRatingRow('Discipline Rating', ratings['disciplineRating'] ?? 0),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            '${value.toStringAsFixed(2)}%', // Display as percentage
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
