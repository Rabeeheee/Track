import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: CustomAppBar(title: 'Diary'),

      bottomNavigationBar: Bottomnav(),
    );
  }
}