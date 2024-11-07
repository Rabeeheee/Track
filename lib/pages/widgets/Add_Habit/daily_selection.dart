import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class DailySelection extends StatefulWidget {
  final Function(List<String>) onDaySelected;
  

  DailySelection({required this.onDaySelected});

  @override
  _DailySelectionState createState() => _DailySelectionState();
}

class _DailySelectionState extends State<DailySelection> {

  List<String> selectedDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<String> daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final List<String> fullDaysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Days:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: themeProvider.themeData.splashColor),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: List.generate(daysOfWeek.length, (index) {
            String day = daysOfWeek[index];
            String fullDay = fullDaysOfWeek[index];
            bool isSelected = selectedDays.contains(fullDay);

            return ChoiceChip(
              label: Text(
                day,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              selected: isSelected,
              selectedColor: Colors.blue,
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedDays.add(fullDay);
                  } else {
                    selectedDays.remove(fullDay);
                  }
                });
                widget.onDaySelected(selectedDays); // Pass updated days
              },
            );
          }),
        ),
      ],
    );
  }
}
