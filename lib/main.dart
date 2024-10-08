import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:trackit/screens/Questions/routine.dart';
import 'package:trackit/screens/Questions/servey.dart';
import 'package:trackit/progressprovider.dart'; 

void main() {
  runApp(TrackIt());
}

class TrackIt extends StatelessWidget {
  const TrackIt({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProgressProvider(), 
      child: MaterialApp(
        title: 'TrackIt',
        home: SurveyScreen(habitProgress: {}), 
      ),
    );
  }
}

