import 'package:flutter/material.dart';
import 'package:trackitapp/services/models/notification_services.dart';

class ReminderWidget extends StatefulWidget {
    final String title;
  final String quote;
  final Function(List<DateTime>) onReminderTimesChanged;
  final DateTime? startDate;

  ReminderWidget({
    required this.onReminderTimesChanged,
    required this.startDate, required this.title, required this.quote, 
  });

  @override
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
        finalReminderTime.add(Duration(days: 1));
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
