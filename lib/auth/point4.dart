import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';

Widget build4(BuildContext context) {
  return const Scaffold(
    backgroundColor: AppColors.backgrey,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 50, right: 50, top: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 300),
                child: Icon(
                  Icons.star_rate_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: 'So, what did he do?\n\n',
                  style: TextStyle(
                    color: Color.fromARGB(231, 255, 255, 255),
                    fontSize: 19,
                    fontFamily: 'Fonts',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text:
                      'Wake up early.\n\nRun, push up, workout.\n\nDrink water.\n\nNo social media.\n\nRead and meditate.\n\nTake cold shower.\n\n',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 19,
                    fontFamily: 'Fonts',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: 'For ',
                  style: TextStyle(
                    color: Color.fromARGB(231, 255, 255, 255),
                    fontSize: 19,
                    fontFamily: 'Fonts',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '10 weeks',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 19,
                    fontFamily: 'Fonts',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ". That's it.",
                  style: TextStyle(
                    color: Color.fromARGB(231, 255, 255, 255),
                    fontSize: 19,
                    fontFamily: 'Fonts',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ])),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 70),
            child: Text(
              'Tap to continue',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
        ),
      ],
    ),
  );
}
