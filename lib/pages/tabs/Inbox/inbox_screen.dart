import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      bottomNavigationBar: Bottomnav(),
    );
  }
}