import 'package:flutter/material.dart';
import 'package:trackit/screens/Questions/apreciate.dart';
import 'package:trackit/screens/Questions/routine.dart';
import 'package:trackit/screens/Questions/servey.dart';
import 'package:trackit/screens/loginpage/Login.dart';
import 'package:trackit/screens/loginpage/getstart.dart';
import 'package:trackit/screens/splash_screen.dart';

void main(){
  runApp(TrackIt());
}
class TrackIt extends StatelessWidget {
  const TrackIt({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RoutineScreen(),
    );
  }
}