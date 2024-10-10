
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trackit/pages/other/result_screen.dart';
import 'package:trackit/utils/colors.dart';

class SplashScreen2 extends StatefulWidget {
  final Map<String, double> surveyRatings;
  final Map<String, double> routineRatings;

  SplashScreen2({required this.surveyRatings, required this.routineRatings});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen2> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _simulateProgress();
  }

  void _simulateProgress() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _progressValue += 0.1;
        if (_progressValue >= 1.0) {
          timer.cancel();

          // Pass the survey and routine ratings to the ResultScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                surveyRatings: widget.surveyRatings,
                routineRatings: widget.routineRatings,
              ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.brush, // Your desired icon
              color: Colors.white,
              size: 50.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Calculating your rating...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: 270,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _progressValue,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '40,000+ members',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
