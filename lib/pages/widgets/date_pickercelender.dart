import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackitapp/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class DatePickercelender extends StatefulWidget {
  final DateTime currentDate;
  final Function(DateTime) onDateSelected;

  const DatePickercelender({Key? key, required this.currentDate, required this.onDateSelected}) : super(key: key);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DatePickercelender> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.currentDate;
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateSelected(selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    DateTime startOfWeek = selectedDate!.subtract(Duration(days: selectedDate!.weekday - 1));

    return GestureDetector(
      onDoubleTap: () => _selectDate(context), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          DateTime date = startOfWeek.add(Duration(days: index)); 
          bool isSelected = date.day == selectedDate!.day && date.month == selectedDate!.month && date.year == selectedDate!.year;

          return Column(
            children: [
              Text(
                DateFormat.E().format(date), 
                style: TextStyle(
                  fontSize: 12,
                  color: themeProvider.themeData.canvasColor,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 4),
              CircleAvatar(
                backgroundColor: isSelected ? Colors.blue : Colors.transparent,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: themeProvider.themeData.canvasColor,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
