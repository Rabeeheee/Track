import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/goal_days_popup.dart';
import 'package:trackitapp/utils/date.dart' as customDate;

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
                Text('Start Date', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Text(
                      customDate.DateUtils.formatDate(
                        selectedStartDate ?? DateTime.now(),
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                    IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedStartDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          onDateChanged(pickedDate);
                        }
                      },
                      icon: const Icon(Icons.calendar_today, size: 15),
                    ),
                  ],
                ),
              ],
            ),
            // Goal Days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Goal Days', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Text(goalDays, style: const TextStyle(fontSize: 12)),
                    IconButton(
                      onPressed: () => _showGoalDaysPopup(context),
                      icon: const Icon(Icons.arrow_forward_ios, size: 15),
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
