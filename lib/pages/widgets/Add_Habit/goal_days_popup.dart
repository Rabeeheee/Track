import 'package:flutter/material.dart';

class GoalDaysPopup extends StatelessWidget {
  final String selectedGoalDays;
  final Function(String) onSelectGoalDays;

  // ignore: use_super_parameters
  const GoalDaysPopup({
    Key? key,
    required this.selectedGoalDays,
    required this.onSelectGoalDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Forever'),
            onTap: () {
              onSelectGoalDays('Forever');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('7 days'),
            onTap: () {
              onSelectGoalDays('7 days');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('21 days'),
            onTap: () {
              onSelectGoalDays('21 days');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('30 days'),
            onTap: () {
              onSelectGoalDays('30 days');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('100 days'),
            onTap: () {
              onSelectGoalDays('100 days');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('365 days'),
            onTap: () {
              onSelectGoalDays('365 days');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
