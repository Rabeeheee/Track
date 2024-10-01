import 'package:flutter/material.dart';
import 'package:trackit/screens/splash_screen.dart';

void main(){
  runApp(TrackIt());
}
class TrackIt extends StatelessWidget {
  const TrackIt({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}