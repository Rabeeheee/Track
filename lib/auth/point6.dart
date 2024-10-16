import 'package:flutter/material.dart';
import 'package:trackitapp/auth/Login.dart';
import 'package:trackitapp/utils/colors.dart';


Widget build6(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    },
    child: Scaffold(
      backgroundColor: AppColors.backgrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Locking in for 66 days isn’t easy.\n\nBut if they can do it,\n',
                        style: TextStyle(
                          color: Color.fromARGB(231, 255, 255, 255),
                          fontSize: 19,
                          fontFamily: 'Fonts',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'you can too.',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 19,
                          fontFamily: 'Fonts',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                height: 285,
                width: 270,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 72, 72, 72),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(4, 4)),
                    ]),
                child: const Padding(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: Column(
                    children: [
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text:
                              '"Last year, I was at the rock bottom.\n\nTrackIt provided ',
                          style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Fonts'),
                        ),
                        TextSpan(
                          text:
                              'a great system to transform my habits and life style.\n\n',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Fonts'),
                        ),
                        TextSpan(
                          text: 'joining TrackIt is ',
                          style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Fonts'),
                        ),
                        TextSpan(
                          text: "the best investment I've ever made.",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Fonts'),
                        )
                      ])),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                    'assets/images/firstavatar.png')),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Parker, used TrackIt for 10 weeks',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Fonts',
                                  color: Color.fromARGB(255, 134, 134, 134)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Text(
                    'Tap to continue',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
