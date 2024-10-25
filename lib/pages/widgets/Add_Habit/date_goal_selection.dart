import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/goal_days_popup.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class DateGoalSelection extends StatelessWidget {
  final DateTime? selectedStartDate;
  final String goalDays;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onGoalChanged;

  DateGoalSelection({
    required this.selectedStartDate,
    required this.goalDays,
    required this.onDateChanged,
    required this.onGoalChanged,
  });

  void _showGoalDaysPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GoalDaysPopup(
          selectedGoalDays: goalDays,
          onSelectGoalDays: (selectedGoal) {
            onGoalChanged(selectedGoal);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Start Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start Date',
                    style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.themeData.splashColor,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(
                        selectedStartDate ??
                            DateTime.now(), 
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          onDateChanged(pickedDate);
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_today,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Goal Days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Goal Days',
                    style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.themeData.splashColor,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text(goalDays,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => _showGoalDaysPopup(context),
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
