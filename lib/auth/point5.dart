import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';

Widget build5(BuildContext context) {
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
                    text: 'Studies show that it takes\n\n',
                    style: TextStyle(
                      color: Color.fromARGB(231, 255, 255, 255),
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '66 days',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' to build life- \n\nchanging habits.With\n\n dedication and a well-\n\ndesigned system,',
                    style: TextStyle(
                      color: Color.fromARGB(231, 255, 255, 255),
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' ',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                   TextSpan(
                    text: " life\n\nreset in 10 weeks is possible.",
                    style: TextStyle(
                      color: AppColors.primaryColor,
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


