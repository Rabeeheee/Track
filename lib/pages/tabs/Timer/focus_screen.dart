import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      bottomNavigationBar: BottomNav(),
    );
  }
}