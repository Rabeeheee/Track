import 'package:flutter/material.dart';

class SurveyQuestion {
  String questionText;
  List<String> options;

   SurveyQuestion(this.questionText, this.options);
}

class Habit {
  late final String title;
  late final String subtitle;
  final String image; 
  

  Habit({required this.title, required this.subtitle, required this.image});

  get avatar => null;
}

