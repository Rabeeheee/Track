import 'package:flutter/material.dart';
import 'package:trackit/color/colors.dart';
import 'package:trackit/screens/Questions/routine.dart';

class Apreciate extends StatelessWidget {
  final VoidCallback onContinue;
  final int habitIndex;
  final List<dynamic> habits;
   final Map<String, double> ratings; 

  const Apreciate({
    required this.onContinue,
    required this.habitIndex,
    required this.habits,
      required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures the progress bar stretches across the screen
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.4,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
            ),
            // Remaining content centered
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
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RoutineScreen(userResponses: [], habitProgress: {},),
                        ));
                      },
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
    );
  }
}