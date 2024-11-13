import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/other/progressprovider.dart';
import 'package:trackitapp/utils/Linear_progress.dart';
import 'package:trackitapp/utils/colors.dart';
import 'package:trackitapp/auth/apreciate.dart';
import 'package:trackitapp/utils/survey_option.dart';
import 'package:trackitapp/utils/theme_provider.dart';
import '../../utils/rating_calculator.dart';

class SurveyQuestion {
  final String questionText;
  final List<String> options;

  SurveyQuestion(this.questionText, this.options);
}

List<SurveyQuestion> questions = [
  SurveyQuestion('How old are you?', ['\t  13 to 17', '\t  18 to 24', '\t  25 to 34', '\t  35 to 44', '\t  45 to 54']),
  SurveyQuestion('How would you describe your life currently?', ['😊 I\'m satisfied', '🙂 I\'m alright', '😐 I\'m doing okay', '😢 I\'m often sad', '😭 I need help']),
  SurveyQuestion('What’s the last time you were proud of yourself?', ['\t  Just today', '\t  Few days ago', '\t  Few weeks ago', '\t  Few months ago', '\t  Too long']),
  SurveyQuestion('What gets you out of bed every morning?', ['\t  Make money', '\t  To not get fired', '\t  To provide for family', '\t  Achieve goals', '\t  I don’t really know']),
  SurveyQuestion('Which words resonate with you most?', ['\t  Under-achieved', '\t  Lack of confidence', '\t  Distracted', '\t  Anxious', '\t  Failed']),
];

class SurveyScreen extends StatefulWidget {
  final Map<String, double> habitProgress;

  const SurveyScreen({required this.habitProgress});

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
        RatingCalculator ratingCalculator = RatingCalculator(userResponses: userResponses);
        Map<String, double> ratings = ratingCalculator.calculateSurveyRatings();

        print('Calculated Ratings: $ratings');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Apreciate(
              surveyRatings: ratings,
              routineRatings: {},
              userResponses: userResponses,
              onContinue: () {},
              habitIndex: 0,
              habits: [],
              ratings: {},
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
        final themeProvider = Provider.of<ThemeProvider>(context);

    final currentQuestion = questions[currentQuestionIndex];
    double progressValue = questionWeights.take(currentQuestionIndex + 1).reduce((a, b) => a + b);

    return 
    SafeArea(
      child: Scaffold(
        
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 900), 
              padding: const EdgeInsets.symmetric(horizontal: 16.0), 
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
                          style:  TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Fonts',
                            color: themeProvider.themeData.splashColor,
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
        ),
      ),
    );
  }
}
