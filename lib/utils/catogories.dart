
const int WISDOM_INDEX = 0;
const int STRENGTH_INDEX = 1;
const int FOCUS_INDEX = 2;
const int CONFIDENCE_INDEX = 3;
const int DISCIPLINE_INDEX = 4;

List<String> categories = [
  "Wisdom",
  "Strength",
  "Focus",
  "Confidence",
  "Discipline",
];

// Initialize ratings for each category
Map<String, double> categoryScores = {
  "Wisdom": 0.0,
  "Strength": 0.0,
  "Focus": 0.0,
  "Confidence": 0.0,
  "Discipline": 0.0,
};
class SurveyQuestion {
  final String questionText;
  final List<String> options;
  final String category; // Add category

  SurveyQuestion(this.questionText, this.options, {required this.category});
}

