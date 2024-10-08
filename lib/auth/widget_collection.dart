import 'package:flutter/material.dart';
import 'package:trackit/auth/point1.dart';
import 'package:trackit/auth/point2.dart';
import 'package:trackit/auth/point3.dart';
import 'package:trackit/auth/point4.dart';
import 'package:trackit/auth/point5.dart';
import 'package:trackit/auth/point6.dart';


class WidgetCollection extends StatefulWidget {
  const WidgetCollection({super.key});

  @override
  State<WidgetCollection> createState() => _WidgetCollectionState();
}

class _WidgetCollectionState extends State<WidgetCollection> {
  
  List<Widget Function(BuildContext)> screens = [
    (context) => build1(context),
    (context) => build2(context),
    (context) => build3(context),
    (context) => build4(context),
    (context) => build5(context),
    (context) => build6(context),

  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          
          setState(() {
            currentIndex = (currentIndex + 1);
          });
        },
        child: screens[currentIndex](context),
      ),
    );
  }
}
