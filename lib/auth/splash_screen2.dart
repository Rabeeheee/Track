import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackitapp/pages/other/result_screen.dart';
import 'package:trackitapp/utils/colors.dart';

class SplashScreen2 extends StatefulWidget {
  final Map<String, double> surveyRatings;
  final Map<String, double> routineRatings;

  // ignore: use_key_in_widget_constructors
  const SplashScreen2(
      {required this.surveyRatings, required this.routineRatings});

  @override
  // ignore: library_private_types_in_public_api
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
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progressValue += 0.1;
        if (_progressValue >= 1.0) {
          timer.cancel();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                surveyRatings: widget.surveyRatings,
                routineRatings: widget.routineRatings,
              ),
            ),
            (route) => false,
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
            const Icon(
              FontAwesomeIcons.feather,
              color: Colors.white,
              size: 50.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Calculating your rating...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 20.0),
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
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryColor),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
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
