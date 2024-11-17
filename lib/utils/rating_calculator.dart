class RatingCalculator {
  final List<int> userResponses;

  RatingCalculator({required this.userResponses});

  // Function to calculate routine ratings
  Map<String, double> calculateRoutineRatings() {
    double totalPoints = 0;

    // Assign points based on userResponses
    for (var response in userResponses) {
      totalPoints += (5 - response); // Adjust for scoring from 5 to 1
    }

    double maxScore =
        userResponses.length * 5; // Max score is 5 points per question

    // Calculate routine ratings as percentages
    return {
      'overallRating': (totalPoints / maxScore) * 100,
      'wisdomRating': (totalPoints / maxScore) * 100,
      'strengthRating': (totalPoints / maxScore) * 100,
      'focusRating': (totalPoints / maxScore) * 100,
      'confidenceRating': (totalPoints / maxScore) * 100,
      'disciplineRating': (totalPoints / maxScore) * 100,
    };
  }

  // Function to calculate survey ratings
  Map<String, double> calculateSurveyRatings() {
    double overallRating = 0;
    double wisdomRating = 0;
    double strengthRating = 0;
    double confidenceRating = 0;
    double focusRating = 0;
    double disciplineRating = 0;

    for (int i = 0; i < userResponses.length; i++) {
      double responseValue = (5 - userResponses[i]).toDouble();

      overallRating += responseValue;

      switch (i) {
        case 1:
          confidenceRating += responseValue;
          break;
        case 2:
          disciplineRating += responseValue;
          break;
        case 3:
          focusRating += responseValue;
          break;
        case 4:
          wisdomRating += responseValue;
          break;
        case 5:
          strengthRating += responseValue;
          break;
      }
    }

    // Normalize the overall rating by dividing by the number of questions
    overallRating /= userResponses.length;

    // Return the ratings for the survey
    return {
      'overallRating': (overallRating / userResponses.length) * 100,
      'wisdomRating': (wisdomRating / userResponses.length) * 100,
      'confidenceRating': (confidenceRating / userResponses.length) * 100,
      'strengthRating': (strengthRating / userResponses.length) * 100,
      'focusRating': (focusRating / userResponses.length) * 100,
      'disciplineRating': (disciplineRating / userResponses.length) * 100,
    };
  }
}
