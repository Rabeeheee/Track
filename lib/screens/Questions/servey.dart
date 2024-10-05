import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit/progressprovider.dart';
import 'package:trackit/screens/Questions/Apreciate.dart';
import 'package:trackit/screens/Questions/Linear_progress.dart';
import 'package:trackit/color/colors.dart';
import 'package:trackit/screens/Questions/result_screen.dart';
import 'package:trackit/screens/Questions/survey_option.dart';

// Survey Question model
class SurveyQuestion {
  final String questionText;
  final List<String> options;

  SurveyQuestion(this.questionText, this.options);
}

List<SurveyQuestion> questions = [
  SurveyQuestion('How old are you?', ['13 to 17', '18 to 24', '25 to 34', '35 to 44', '45 to 54']),
  SurveyQuestion('How would you describe your life currently?', ['😊 I\'m satisfied', '🙂 I\'m alright', '😐 I\'m doing okay', '😢 I\'m often sad', '😭 I need help']),
  SurveyQuestion('What’s the last time you were proud of yourself?', ['Just today', 'Few days ago', 'Few weeks ago', 'Few months ago', 'Too long']),
  SurveyQuestion('What gets you out of bed every morning?', ['Make money', 'To not get fired', 'To provide for family', 'Achieve goals', 'I don’t really know']),
  SurveyQuestion('Which words resonate with you most?', ['Under-achieved', 'Lack of confidence', 'Distracted', 'Anxious', 'Failed']),
];

class SurveyScreen extends StatefulWidget {
  final Map<String, double> habitProgress;

  SurveyScreen({required this.habitProgress});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<int> userResponses = List.filled(questions.length, 0);
  int currentQuestionIndex = 0;
  final List<double> questionWeights = List.filled(questions.length, 0.07); // Adjust weights accordingly

  void navigateToNextQuestion(String answer) {
  setState(() {
    final currentQuestion = questions[currentQuestionIndex];
    int answerIndex = currentQuestion.options.indexOf(answer);
    userResponses[currentQuestionIndex] = (answerIndex >= 0) ? 5 - answerIndex : 0;

    Provider.of<ProgressProvider>(context, listen: false).updateIndex(currentQuestionIndex);

    if (currentQuestionIndex == questions.length - 1) {
      // At the end of the survey, calculate ratings
      Map<String, double> ratings = RatingCalculator.calculateRatings(userResponses);

      // Navigate to the ResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            ratings: ratings, // Pass calculated ratings to the result screen
          ),
        ),
      );
    } else {
      currentQuestionIndex++;
    }
  });
}


  void navigateToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        Provider.of<ProgressProvider>(context, listen: false).updateIndex(currentQuestionIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    double progressValue = questionWeights.take(currentQuestionIndex + 1).reduce((a, b) => a + b);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(15, 255, 255, 255),
              Color.fromARGB(39, 0, 0, 0),
              Color.fromARGB(14, 255, 255, 255),
              Color.fromARGB(39, 0, 0, 0),
              Color.fromARGB(14, 255, 255, 255),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              CommonProgressIndicator(progressValue: progressValue),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 35,
                    child: IconButton(
                      onPressed: navigateToPreviousQuestion,
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      currentQuestion.questionText,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Fonts',
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              for (var option in currentQuestion.options)
                SurveyOption(
                  emoji: option.substring(0, 2),
                  text: option.substring(2),
                  onTap: () => navigateToNextQuestion(option),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Rating Calculator class
// Adjust this method in the RatingCalculator class
class RatingCalculator {
  static Map<String, double> calculateRatings(List<int> userResponses) {
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

    // Total responses and weights for each question.
    double totalPoints = userResponses.reduce((a, b) => a + b).toDouble();
    double maxScore = userResponses.length * 5;

    // Calculate ratings based on specific logic
    double overallRating = (totalPoints / maxScore) * 100;

    // Distributing ratings based on specific logic
    double wisdomRating = overallRating * 0.5; // Example weight
    double strengthRating = overallRating * 0.2; // Example weight
    double focusRating = overallRating * 0.2; // Example weight
    double confidenceRating = overallRating * 0.1; // Example weight
    double disciplineRating = overallRating * 0.1; // Example weight

    return {
      'overallRating': overallRating,
      'wisdomRating': wisdomRating,
      'strengthRating': strengthRating,
      'focusRating': focusRating,
      'confidenceRating': confidenceRating,
      'disciplineRating': disciplineRating,
    };
  }
}
