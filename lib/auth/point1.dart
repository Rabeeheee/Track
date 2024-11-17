// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';

//========================

Widget build1(BuildContext context) {
  return const Scaffold(
    backgroundColor: AppColors.backgrey,
    body: Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, top: 110),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'At some stage, most people will experience\n\n',
                    style: TextStyle(
                      color: Color.fromARGB(231, 255, 255, 255),
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' a lack of discipline, low energy, and a loss of\n\ndirection and motivation ',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'in their lives.',
                    style: TextStyle(
                      color: Color.fromARGB(231, 255, 255, 255),
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ]),
              )
            ],
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 70),
              child: Text(
                'Tap to continue',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
