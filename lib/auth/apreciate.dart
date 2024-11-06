import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';
import 'package:trackitapp/pages/other/routine.dart';

class Apreciate extends StatelessWidget {
  final VoidCallback onContinue;
  final int habitIndex;
  final List<dynamic> habits;
  final Map<String, double> ratings;
  final List<int> userResponses;
  final Map<String, double> surveyRatings; 
  final Map<String, double> routineRatings;

  const Apreciate({
    required this.onContinue,
    required this.habitIndex,
    required this.habits,
    required this.ratings,
    required this.userResponses,
    required this.surveyRatings, 
    required this.routineRatings, 
  });

  void navigateToNextScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutineScreen(
          userResponses: userResponses,
          habitProgress: const {}, 
          surveyRatings: surveyRatings,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   

    return SafeArea(
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
               constraints: BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 0.4,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "I'm proud of you for wanting\n to make changes",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Fonts',
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '🔥',
                            style: TextStyle(fontSize: 60),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Answer all questions honestly.',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Fonts',
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => navigateToNextScreen(context),
                            child: const Text(
                              'Got it',
                              style: TextStyle(
                                fontFamily: 'Fonts',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondaryColor,
                              foregroundColor: AppColors.backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
