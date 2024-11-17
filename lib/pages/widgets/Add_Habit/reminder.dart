import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/services/models/notification_services.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class ReminderWidget extends StatefulWidget {
  final String title;
  final String quote;
  final Function(List<DateTime>) onReminderTimesChanged;
  final DateTime? startDate;

  const ReminderWidget({super.key, 
    required this.onReminderTimesChanged,
    required this.startDate,
    required this.title,
    required this.quote,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ReminderWidgetState createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  List<DateTime> selectedReminderTimes = [];
  final NotificationServices notificationService = NotificationServices();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && widget.startDate != null) {
      final DateTime finalReminderTime = DateTime(
        widget.startDate!.year,
        widget.startDate!.month,
        widget.startDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        selectedReminderTimes.add(finalReminderTime);
      });

      widget.onReminderTimesChanged(selectedReminderTimes);

      DateTime now = DateTime.now();
      if (finalReminderTime.isBefore(now)) {
        finalReminderTime.add(const Duration(days: 1));
      }
      Duration delay = finalReminderTime.difference(now);

      notificationService.scheduleNotification(
        id: finalReminderTime.hashCode,
        title: widget.title,
        body: widget.quote,
        delay: delay.inSeconds,
      );
    }
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
            Row(
              children: [
                Text(
                  'Reminder',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeData.splashColor),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blueAccent),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
            Column(
              children: [
                ...selectedReminderTimes.map((reminderTime) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('hh:mm a').format(reminderTime),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            selectedReminderTimes.remove(reminderTime);
                            widget
                                .onReminderTimesChanged(selectedReminderTimes);
                          });
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
