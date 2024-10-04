// rating_calculator.dart

class RatingCalculator {
  final List<int> userResponses;

  RatingCalculator({required this.userResponses});

  Map<String, double> calculateRatings() {
    // Check if userResponses is empty
    if (userResponses.isEmpty) {
      return {
        'overallRating': 0,
        'wisdomRating': 0,
        'strengthRating': 0,
        'focusRating': 0,
        'confidenceRating': 0,
        'disciplineRating': 0,
      };
    }

    // Total points accumulated from user responses
    double totalPoints = userResponses.reduce((a, b) => a + b).toDouble();

    // Calculate the maximum possible score
    double maxScore = userResponses.length * 5; // 5 points for each question

    // Calculate ratings as percentages
    return {
      'overallRating': (totalPoints / maxScore) * 100,
      'wisdomRating': (totalPoints / maxScore) * 100,
      'strengthRating': (totalPoints / maxScore) * 100,
      'focusRating': (totalPoints / maxScore) * 100,
      'confidenceRating': (totalPoints / maxScore) * 100,
      'disciplineRating': (totalPoints / maxScore) * 100,
    };
  }
}
