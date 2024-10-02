import 'package:flutter/material.dart';
import 'package:trackit/color/colors.dart';

class Apreciate extends StatelessWidget {
  final VoidCallback onContinue;

  const Apreciate({required this.onContinue});

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "I'm proud of you for wanting\n to make changes",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Fonts',
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '🔥',
                style: TextStyle(fontSize: 60),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Answer all questions honestly.',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Fonts',
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: 
                   onContinue,
                
                child: Text(
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
    );
  }
}
