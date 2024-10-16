 import 'package:flutter/material.dart';
import 'package:trackitapp/utils/colors.dart';

 Widget build2(BuildContext context, ) {
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
                    text: 'Alex is one of them\n',
                    style: TextStyle(
                      color: Color.fromARGB(231, 255, 255, 255),
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '12 months ago, ',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' he was at the lowest of his life,\n',
                    style: TextStyle(
                      color: Color.fromARGB(231, 255, 255, 255),
                      fontSize: 19,
                      fontFamily: 'Fonts',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'feeling like a piece of sh*t every day. ',
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
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 120, right: 10, left: 30),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/images/arrowup.png'),
                          width: 70,
                          height: 100,
                        ),
                        Text(
                          'No purpose',
                          style: TextStyle(
                            color: Color.fromARGB(231, 255, 255, 255),
                            fontSize: 12,
                            fontFamily: 'Fonts',
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image(
                  image: AssetImage('assets/images/man before.jpg'),
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        Text(
                          '        No\nconfidence',
                          style: TextStyle(
                            color: Color.fromARGB(231, 255, 255, 255),
                            fontSize: 12,
                            fontFamily: 'Fonts',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Image(
                          image: AssetImage('assets/images/arrowdown.png'),
                          width: 70,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          ),
        ],
      ),
    );
  }