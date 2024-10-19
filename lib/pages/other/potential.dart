
import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';

import 'package:trackitapp/pages/tabs/habit_screen.dart';

class PotentialScreen extends StatelessWidget {
  final Map<String, double> adjustedRatings;

  PotentialScreen({required this.adjustedRatings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Potential Rating',
              style: TextStyle(
                fontFamily: 'Fonts',
                color: AppColors.secondaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Based on your answers, this is your potential TrackIt rating, reflecting your possible lifestyle and habits.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            Flexible(
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 165 / 115,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  String title;
                  double rating;
              
                  switch (index) {
                    case 0:
                      title = 'Overall';
                      rating = adjustedRatings['overallRating'] ?? 0;
                      break;
                    case 1:
                      title = 'Wisdom';
                      rating = adjustedRatings['wisdomRating'] ?? 0;
                      break;
                    case 2:
                      title = 'Strength';
                      rating = adjustedRatings['strengthRating'] ?? 0;
                      break;
                    case 3:
                      title = 'Focus';
                      rating = adjustedRatings['focusRating'] ?? 0;
                      break;
                    case 4:
                      title = 'Confidence';
                      rating = adjustedRatings['confidenceRating'] ?? 0;
                      break;
                    case 5:
                      title = 'Discipline';
                      rating = adjustedRatings['disciplineRating'] ?? 0;
                      break;
                    default:
                      title = '';
                      rating = 0;
                  }
              
                  // Set colors for the overall rating section
                  Color backgroundColor;
                  Color textColor;
                  Color progressColor;
                  Color progressBack;
                  Color addColor;
              
                  if (index == 0) {
                    backgroundColor = Colors.green;
                    textColor = Colors.white;
                    progressColor = Colors.white;
                    progressBack = const Color.fromARGB(185, 76, 175, 79);
                    addColor = Colors.yellow;
                  } else {
                    backgroundColor = Colors.white;
                    textColor = Colors.black;
                    progressColor = Colors.green;
                    progressBack = const Color.fromARGB(137, 255, 255, 255);
                    addColor = Colors.green;
                  }
              
                  return Container(
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
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  '${(rating + 40).toStringAsFixed(0)}', // Use toStringAsFixed(0) to avoid decimal places
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Text('(+40)',style: TextStyle(
                                color:addColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              ),)
                            ],
                          ),
                       
                          Flexible(
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: (rating+40) / 100,
                                  backgroundColor: progressBack,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      progressColor),
                                ),
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
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8,bottom: 100),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                           HabitScreen(name: '', quote: '', selectedAvatarPath: '',),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View my program',
                        style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
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
            ),
          ],
        ),
      ),
    );
  }
}
