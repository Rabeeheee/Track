import 'package:flutter/material.dart';
import 'package:trackitapp/services/models/notification_services.dart';

class ReminderWidget extends StatefulWidget {
  final Function(List<DateTime>) onReminderTimesChanged;

  ReminderWidget({required this.onReminderTimesChanged});

  @override
  _ReminderWidgetState createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  List<DateTime> selectedReminderTimes = [];
  final NotificationServices notificationService = NotificationServices();

  // Function to pick date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      _selectTime(context, pickedDate);
    }
  }

  // Function to pick time and combine with the selected date
  Future<void> _selectTime(BuildContext context, DateTime selectedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final DateTime finalReminderTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      
      setState(() {
        selectedReminderTimes.add(finalReminderTime);
      });

      widget.onReminderTimesChanged(selectedReminderTimes);
      
      // Calculate the delay in seconds
      DateTime now = DateTime.now();
      if (finalReminderTime.isBefore(now)) {
        finalReminderTime.add(Duration(days: 1));
      }
      Duration delay = finalReminderTime.difference(now);

      // Schedule the notification for the selected date and time
      notificationService.scheduleNotification(
        id: finalReminderTime.hashCode,  // Use the final time's hashCode for unique ID
        title: 'Habit Reminder',
        body: 'Your scheduled habit reminder!',
        delay: delay.inSeconds,  // Delay in seconds
      );
    }
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
            Row(
              children: [
                Text(
                  'Reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blueAccent),
                  onPressed: () => _selectDate(context),
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
                          const Icon(Icons.access_time, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text(
                            '${reminderTime.toLocal()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            selectedReminderTimes.remove(reminderTime);
                            widget.onReminderTimesChanged(selectedReminderTimes);
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
