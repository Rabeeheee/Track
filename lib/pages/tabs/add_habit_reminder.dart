import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/daily_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/date_goal_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/frequency_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/interval_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/part_of_day_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/reminder.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/section_title.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/weekly_selection.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/notification_services.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class AddHabitReminder extends StatefulWidget {
  const AddHabitReminder({super.key});

  @override
  State<AddHabitReminder> createState() => _AddHabitReminderState();
}

class _AddHabitReminderState extends State<AddHabitReminder> {
  String? selectedFrequency;
  List<String> selectedDays = [];
  int? selectedWeekdays = 1;
  int? intervalDays = 1;
  DateTime? selectedStartDate = DateTime.now();
  String goalDays = 'Forever';
  String selectedPartOfDay = 'Morning';
  List<DateTime> reminderTimes = []; // List to hold selected reminder times

  final NotificationServices notificationService = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
  }

  

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'New Habit',
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: themeProvider.themeData.cardColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitleWidget(
                          title: 'Frequency',
                          isSelected: selectedFrequency == 'Frequency'),
                      const SizedBox(height: 16),
                      FrequencySelectionWidget(
                        selectedFrequency: selectedFrequency,
                        onSelectFrequency: (frequency) {
                          setState(() {
                            selectedFrequency = frequency;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      if (selectedFrequency == 'Daily')
                        DailySelection(
                          onDaySelected: (updatedDays) {
                            setState(() {
                              selectedDays = updatedDays;
                            });
                          },
                        ),
                      if (selectedFrequency == 'Weekly')
                        WeeklySelectionWidget(
                          selectedWeekdays: selectedWeekdays,
                          onSelectWeekday: (weekday) {
                            setState(() {
                              selectedWeekdays = weekday;
                            });
                          },
                        ),
                      if (selectedFrequency == 'Interval')
                        IntervalSelectionWidget(
                          intervalDays: intervalDays,
                          onSelectInterval: (days) {
                            setState(() {
                              intervalDays = days;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DateGoalSelection(
                selectedStartDate: selectedStartDate,
                goalDays: goalDays,
                onDateChanged: (pickedDate) {
                  setState(() {
                    selectedStartDate = pickedDate;
                  });
                },
                onGoalChanged: (selectedGoal) {
                  setState(() {
                    goalDays = selectedGoal;
                  });
                },
              ),
              const SizedBox(height: 10),
              PartOfDaySelection(
                selectedPartOfDay: selectedPartOfDay,
                onSelectPartOfDay: (partOfDay) {
                  setState(() {
                    selectedPartOfDay = partOfDay;
                  });
                },
                onPartOfDaySelected: (String part) {},
              ),
              const SizedBox(height: 10),
              ReminderWidget(
                onReminderTimesChanged: (times) {
                  setState(() {
                    reminderTimes = times;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  if (reminderTimes.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select reminder times!')),
                    );
                    return;
                  }

                  // Loop through each selected reminder time
                 // Schedule the notification for the selected date and time
for (DateTime reminderTime in reminderTimes) {
  DateTime now = DateTime.now();
  DateTime scheduledDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    reminderTime.hour,
    reminderTime.minute,
  );

  // If the selected time is in the past for today, schedule it for the next day
  if (scheduledDateTime.isBefore(now)) {
    scheduledDateTime = scheduledDateTime.add(Duration(days: 1));
  }

  // Calculate the delay in seconds
  Duration delay = scheduledDateTime.difference(now);

  notificationService.scheduleNotification(
    id: scheduledDateTime.hashCode,  // Use hashCode for unique ID
    title: 'habit reminder',
    body: 'Time for your habit!',
    delay: delay.inSeconds,  // Delay in seconds
  );
}


                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Habit reminder saved!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
