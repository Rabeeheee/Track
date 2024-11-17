import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/Habit/add_new_habit.dart';
import 'package:trackitapp/services/models/modals.dart';
import 'package:trackitapp/utils/colors.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewHabit(
                      habitId: 0,
                      title: habit.title,
                      subtitle: habit.subtitle,
                      description: '',
                    )));
      },
      child: Card(
        color: themeProvider.themeData.cardColor,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(habit.image),
          ),
          title: Text(
            habit.title,
            style: TextStyle(
              color: themeProvider.themeData.splashColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            habit.subtitle,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
