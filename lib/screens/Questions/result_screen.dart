import 'dart:ffi';
import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackit/color/colors.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, double> surveyRatings;
  final Map<String, double> routineRatings;

  ResultScreen({required this.surveyRatings, required this.routineRatings});

  @override
  Widget build(BuildContext context) {
    double overallRating = (surveyRatings['overallRating'] ?? 0) +
        (routineRatings['overallRating'] ?? 0);
    double wisdomRating = (surveyRatings['wisdomRating'] ?? 0) +
        (routineRatings['wisdomRating'] ?? 0);
    double strengthRating = (surveyRatings['strengthRating'] ?? 0) +
        (routineRatings['strengthRating'] ?? 0);
    double focusRating = (surveyRatings['focusRating'] ?? 0) +
        (routineRatings['focusRating'] ?? 0);
    double confidenceRating = (surveyRatings['confidenceRating'] ?? 0) +
        (routineRatings['confidenceRating'] ?? 0);
    double disciplineRating = (surveyRatings['disciplineRating'] ?? 0) +
        (routineRatings['disciplineRating'] ?? 0);

    
    double adjustRating(double rating) {
      if (rating > 50) {
       
        int randomAdjustment = Random().nextInt(10);
        return rating - (rating - 50) - randomAdjustment;
      }
      return rating;
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your TrackIt Rating',
              style: TextStyle(
                fontFamily: 'Fonts',
                color: AppColors.secondaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Based on your answer, this is your current TrackIt rating, which reflects your lifestyle and habits now.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 400,
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 165 / 125,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  String title;
                  double rating;

                  switch (index) {
                    case 0:
                      title = 'Overall';
                      rating = overallRating;
                      break;
                    case 1:
                      title = 'Wisdom';
                      rating = wisdomRating;
                      break;
                    case 2:
                      title = 'Strength';
                      rating = strengthRating;
                      break;
                    case 3:
                      title = 'Focus';
                      rating = focusRating;
                      break;
                    case 4:
                      title = 'Confidence';
                      rating = confidenceRating;
                      break;
                    case 5:
                      title = 'Discipline';
                      rating = disciplineRating;
                      break;
                    default:
                      title = '';
                      rating = 0;
                  }

                  
                  rating = adjustRating(rating);

                  
                  Color backgroundColor;
                  Color textColor;
                  Color progressColor;
                  Color progressBack;

                  if (index == 0) { 
                    backgroundColor = AppColors.red; 
                    textColor = Colors.white;
                    progressColor = Colors.white;
                    progressBack = const Color.fromARGB(161, 255, 9, 9);
                  } else {
                    backgroundColor = Colors.white;
                    textColor = Colors.black;
                    progressColor = AppColors.red;
                    progressBack = const Color.fromARGB(137, 255, 255, 255);
                  }

                  return Container(
                    width: 165,
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: backgroundColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.gpp_good_rounded,
                                  color: textColor,
                                  size: 25,
                                ),
                              ),
                              SizedBox(width: 5), 
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  '${rating.toStringAsFixed(2)}', 
                                  style: TextStyle(
                                    color: textColor, 
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), 
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
                                value: rating / 100,
                                backgroundColor: progressBack,
                                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 130),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                 
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See potential rating',
                      style: TextStyle(color: AppColors.secondaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.secondaryColor,
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
