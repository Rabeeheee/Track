import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:trackit/screens/Questions/routine.dart';
import 'package:trackit/screens/Questions/servey.dart';
import 'package:trackit/progressprovider.dart'; // Import your ProgressProvider

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
        home: SurveyScreen(), 
      ),
    );
  }
}
