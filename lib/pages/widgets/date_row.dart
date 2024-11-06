
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackitapp/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class DateRow extends StatelessWidget {
  final DateTime currentDate;

  const DateRow({Key? key, required this.currentDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (index) {
        DateTime date = currentDate.subtract(Duration(days: currentDate.weekday - 1 - index));
        bool isSelected = date.day == currentDate.day;
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
                  color: isSelected ? Colors.white : themeProvider.themeData.canvasColor,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
