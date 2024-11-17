// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/daily_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/date_goal_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/frequency_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/part_of_day_selection.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/reminder.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/section_title.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/weekly_selection.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/services/models/notification_services.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class AddHabitReminder extends StatefulWidget {
  final String title;
  final String quote;
  final String? image;
  final int habitId;
  final String description;

  const AddHabitReminder(
      {super.key,
      required this.title,
      required this.quote,
      required this.image,
      required this.habitId,
      required this.description});

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
  List<DateTime> reminderTimes = [];

  final NotificationServices notificationService = NotificationServices();
  final HiveService _hiveService = HiveService();

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
                      ],
                    )),
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
                startDate: selectedStartDate,
                onReminderTimesChanged: (times) {
                  setState(() {
                    reminderTimes = times;
                  });
                },
                title: widget.title,
                quote: widget.quote,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // ignore: sort_child_properties_last
                  child: const Text('Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Fonts')),
                  onPressed: () async {
                    if (widget.title.isNotEmpty && widget.quote.isNotEmpty) {
                      int habitId = widget.habitId;

                      // ignore: avoid_print
                      print('not empty');

                      AddhabitModal? existingHabit =
                          await _hiveService.getHabitById(habitId);

                      AddhabitModal habitData = AddhabitModal(
                        name: widget.title,
                        quote: widget.quote,
                        selectedAvatarPath: widget.image,
                        goalDays: goalDays,
                        frequency: selectedFrequency ?? 'Daily',
                        partOfDay: selectedPartOfDay,
                        isCompleted: existingHabit?.isCompleted ?? false,
                        id: habitId,
                        description: widget.description,
                      );

                      await _hiveService.saveHabit(habitData);

                      if (existingHabit != null) {}

                      for (DateTime reminderTime in reminderTimes) {
                        DateTime now = DateTime.now();
                        DateTime scheduledDateTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          reminderTime.hour,
                          reminderTime.minute,
                        );

                        if (scheduledDateTime.isBefore(now)) {
                          scheduledDateTime =
                              scheduledDateTime.add(const Duration(days: 1));
                        }

                        Duration delay = scheduledDateTime.difference(now);

                        notificationService.scheduleNotification(
                          id: habitId,
                          title: widget.title,
                          body: widget.quote,
                          delay: delay.inSeconds,
                        );
                      }

                      // ignore: avoid_print
                      print(widget.title);
                      // ignore: avoid_print
                      print('snackbar top');
                      // ignore: duplicate_ignore
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Habit saved succesfully!',
                            style: TextStyle(
                              color: themeProvider.themeData.splashColor,
                            ),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const BottomNav()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.themeData.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
