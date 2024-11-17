import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';

Widget build3(BuildContext context) {
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
              SizedBox(
                height: 10,
              ),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text:
                        'This is Alex now\n\nEnergized, motivated, confident, ripped.\n\nAnd most importantly, he ',
                    style: TextStyle(
                      color: Color.fromARGB(231, 255, 255, 255),
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    )),
                TextSpan(
                  text: 'got his life back together.',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image(
                image: AssetImage('assets/images/man after.jpg'),
                width: 140,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 70),
                child: Text(
                  'Tap to continue',
                  style: TextStyle(color: AppColors.grey),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
