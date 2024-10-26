import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';

class PriorityScreen extends StatelessWidget {
  const PriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNav(),
    );
  }
}