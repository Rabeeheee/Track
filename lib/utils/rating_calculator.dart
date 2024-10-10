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
    
    double maxScore = userResponses.length * 5; // Max score is 5 points per question

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
    double confidenceRating = 0;
    double focusRating = 0;
    double disciplineRating = 0;

    // Loop through user responses and assign ratings based on question context
    for (int i = 0; i < userResponses.length; i++) {
      double responseValue = (5 - userResponses[i]).toDouble(); // Adjust for scoring from 5 to 1

      // Add to overall rating
      overallRating += responseValue;

      // Add to specific ratings based on question index
      switch (i) {
        case 1: // For a question related to confidence
          confidenceRating += responseValue;
          break;
        case 2: // For a question related to discipline
          disciplineRating += responseValue;
          break;
        case 3: // For a question related to focus
          focusRating += responseValue;
          break;
        case 4: // For a question related to wisdom
          wisdomRating += responseValue;
          break;
      }
    }

    // Normalize the overall rating by dividing by the number of questions
    overallRating /= userResponses.length;

    // Return the ratings for the survey
    return {
      'overallRating': overallRating,
      'wisdomRating': wisdomRating,
      'confidenceRating': confidenceRating,
      'focusRating': focusRating,
      'disciplineRating': disciplineRating,
    };
  }
}
