import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNav(),
    );
  }
}