import 'dart:ffi';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // First Container
                Container(
                  width: 165, // Set a fixed width for the container
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppColors.red,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.all(8.0), // Add padding around the content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align children to the start (left)
                      children: [
                        const Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Align to the top
                          children: [
                            Icon(
                              Icons.star_rate_rounded, // Add an icon
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(width: 5), // Space between icon and text
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Overall', // Display label
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5),
                          child: Text(
                            ' ${overallRating.toStringAsFixed(2)}', // Display rating
                            style: TextStyle(color: Colors.white, fontSize: 32),
                          ),
                        ),
                        SizedBox(
                            height:
                                10), // Space between rating text and progress bar
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
                              value: (overallRating) /100,
                              backgroundColor: const Color.fromARGB(130, 255, 9, 9),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondaryColor),
                                  
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Second Container
                 Container(
                  width: 165, // Set a fixed width for the container
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.all(8.0), // Add padding around the content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align children to the start (left)
                      children: [
                        const Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Align to the top
                          children: [
                          
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(
                                FontAwesomeIcons.brain, // Add an icon
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            SizedBox(width: 5), // Space between icon and text
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Wisdom', // Display label
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5),
                          child: Text(
                            ' ${wisdomRating.toStringAsFixed(2)}', // Display rating
                            style: TextStyle(color: Colors.black, fontSize: 32),
                          ),
                        ),
                        SizedBox(
                            height:
                                10), // Space between rating text and progress bar
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
                              value: (wisdomRating) /100,
                              backgroundColor: const Color.fromARGB(137, 255, 255, 255),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                 Container(
                  width: 165, // Set a fixed width for the container
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.all(8.0), // Add padding around the content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align children to the start (left)
                      children: [
                        const Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Align to the top
                          children: [
                          
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(
                                FontAwesomeIcons.brain, // Add an icon
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            SizedBox(width: 5), // Space between icon and text
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Wisdom', // Display label
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5),
                          child: Text(
                            ' ${wisdomRating.toStringAsFixed(2)}', // Display rating
                            style: TextStyle(color: Colors.black, fontSize: 32),
                          ),
                        ),
                        SizedBox(
                            height:
                                10), // Space between rating text and progress bar
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
                              value: (wisdomRating) /100,
                              backgroundColor: const Color.fromARGB(137, 255, 255, 255),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                 Container(
                  width: 165, // Set a fixed width for the container
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.all(8.0), // Add padding around the content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align children to the start (left)
                      children: [
                        const Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Align to the top
                          children: [
                          
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(
                                FontAwesomeIcons.brain, // Add an icon
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            SizedBox(width: 5), // Space between icon and text
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Wisdom', // Display label
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 5),
                          child: Text(
                            ' ${wisdomRating.toStringAsFixed(2)}', // Display rating
                            style: TextStyle(color: Colors.black, fontSize: 32),
                          ),
                        ),
                        SizedBox(
                            height:
                                10), // Space between rating text and progress bar
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
                              value: (wisdomRating) /100,
                              backgroundColor: const Color.fromARGB(137, 255, 255, 255),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
