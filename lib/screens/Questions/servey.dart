import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit/progressprovider.dart';
import 'package:trackit/screens/Questions/Linear_progress.dart';
import 'package:trackit/screens/Questions/apreciate.dart';
import 'package:trackit/screens/Questions/modals.dart';
import 'package:trackit/screens/Questions/routine.dart';
import 'package:trackit/screens/Questions/survey_option.dart';
import 'package:trackit/color/colors.dart';

List<SurveyQuestion> questions = [
  SurveyQuestion(
    'How old are you?',
    [
      '13 to 17',
      '18 to 24',
      '25 to 34',
      '35 to 44',
      '45 to 54'
    ],
  ),
  SurveyQuestion(
    'How would you describe your life currently?',
    [
      '😊 I\'m satisfied with my life now',
      '🙂 I\'m alright and want to self-improve',
      '😐 I\'m doing okay, not good or bad',
      '😢 I\'m often sad and rarely happy',
      '😭 I\'m at the lowest and need help'
    ],
  ),
  SurveyQuestion(
    'What’s the last time you were proud of yourself?',
    [
      'Just today',
      'Few days ago',
      'Few weeks ago',
      'Few months ago',
      'Too long I can’t remember'
    ],
  ),
  SurveyQuestion(
    'What gets you out of bed every morning?',
    [
      'Make money to support my needs',
      'To not get fired or expelled',
      'To provide for my family',
      'Achieve my goals and dreams',
      'I don’t really know'
    ],
  ),
  SurveyQuestion(
    'Which of the following words resonate with you most?',
    ['Under-achieved', 'Lack of confidence', 'Distracted', 'Anxious', 'Failed'],
  ),
];

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<int> userResponses =
      List.filled(5, 0); // Adjusted size to match the number of questions
  int currentQuestionIndex = 0;

  // List to hold the contribution of each question to the progress
  final List<double> questionWeights = [
    0.07,
    0.07,
    0.07,
    0.07,
    0.07
  ]; // Each question contributes 20%

  void navigateToNextQuestion(String answer) {
    setState(() {
      final currentQuestion = questions[currentQuestionIndex];
      int answerIndex = currentQuestion.options.indexOf(answer);

      if (answerIndex >= 0 && answerIndex < currentQuestion.options.length) {
        userResponses[currentQuestionIndex] = 5 - answerIndex;
      } else {
        userResponses[currentQuestionIndex] = 0;
      }

      Provider.of<ProgressProvider>(context, listen: false)
          .updateIndex(currentQuestionIndex);

      if (currentQuestionIndex == questions.length - 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Apreciate(
                onContinue: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RoutineScreen()));
                },
                habitIndex: 0,
                habits: []),
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
        Provider.of<ProgressProvider>(context, listen: false)
            .updateIndex(currentQuestionIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    // Calculate the progress value based on the question index and its weight
    double progressValue = 0;
    for (int i = 0; i <= currentQuestionIndex; i++) {
      progressValue += questionWeights[i];
    }

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
              CommonProgressIndicator(
                progressValue: progressValue,
              ),
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
