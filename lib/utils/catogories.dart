// ignore: constant_identifier_names
const int WISDOM_INDEX = 0;
// ignore: constant_identifier_names
const int STRENGTH_INDEX = 1;
// ignore: constant_identifier_names
const int FOCUS_INDEX = 2;
// ignore: constant_identifier_names
const int CONFIDENCE_INDEX = 3;
// ignore: constant_identifier_names
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
