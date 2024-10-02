import 'package:flutter/material.dart';
import 'package:trackit/screens/Questions/apreciate.dart';
import 'package:trackit/screens/Questions/modals.dart';
import 'package:trackit/screens/Questions/survey_option.dart';
import 'result_page.dart';
import 'package:trackit/color/colors.dart';

List<SurveyQuestion> questions = [
  SurveyQuestion(
    'How old are you?',
    ['🏃🏻‍♂️13 to 17', '🕺18 to 24', '🧍‍♂️25 to 34', '🧑‍🦯35 to 44', '👨‍🦽 45 to 54'],
  ),
  SurveyQuestion(
    'How would you describe your life currently?',
    ['😊 I\'m satisfied with my life now', '🙂 I\'m alright and want to self-improve', '😐 I\'m doing okay, not good or bad', '😢 I\'m often sad and rarely happy', '😭 I\'m at the lowest and need help'],
  ),
   SurveyQuestion(
    'What’s the last time you wereproud of yourself?',
    ['Just today', 'Few days ago', 'Few weeks ago', 'Few moths ago', 'Too long I can’t remember'],
  ),
   SurveyQuestion(
    'What’s gets you out of bed every morning?',
    ['Make money to support my needs', 'To not get fired or expelled', 'To provide for my family', 'Achieve my goals and dreams', 'I don’t really know'],
  ),
   SurveyQuestion(
    'Which of the following wordsresonate with you most?',
    ['Under-achieved', 'Lack of confidence', 'Distracted', 'Anxious', 'Failed'],
  ),
 
];

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  List<int> userResponses = List.filled(10, 0); 
  int currentQuestionIndex = 0;
void navigateToNextQuestion(String answer) {
  setState(() {
    
    final currentQuestion = questions[currentQuestionIndex];

    
    int answerIndex = currentQuestion.options.indexOf(answer);
    
  
    if (answerIndex >= 0 && answerIndex < currentQuestion.options.length) {
      userResponses[currentQuestionIndex] = 5 - answerIndex;
    } else {
      userResponses[currentQuestionIndex] = 0; 
    }

   
    if (currentQuestionIndex == 4) { 
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Apreciate(
            onContinue: () {
             
              Navigator.pop(context); 
              currentQuestionIndex++;
              setState(() {}); 
            },
          ),
        ),
      );
    } else if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(responses: userResponses),
        ),
      );
    }
  });
}

  void navigateToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

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
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / questions.length,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 35,
                    child: IconButton(
                      onPressed: () {
                        navigateToPreviousQuestion();
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      currentQuestion.questionText,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Fonts',
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
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
