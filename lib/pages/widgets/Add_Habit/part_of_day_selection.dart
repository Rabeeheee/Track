import 'package:flutter/material.dart';

class PartOfDaySelection extends StatefulWidget {
  final String selectedPartOfDay;
  final Function(String) onSelectPartOfDay;

  const PartOfDaySelection({
    Key? key,
    required this.selectedPartOfDay,
    required this.onSelectPartOfDay, required Null Function(String part) onPartOfDaySelected,
  }) : super(key: key);

  @override
  _PartOfDaySelectionState createState() => _PartOfDaySelectionState();
}

class _PartOfDaySelectionState extends State<PartOfDaySelection> {
  late String selectedPart;

  @override
  void initState() {
    super.initState();
    selectedPart = widget.selectedPartOfDay;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Part of Day',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Fonts',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).splashColor,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSelectionButton('Morning'),
                  SizedBox(width: 10), 
                  _buildSelectionButton('Afternoon'),
                  SizedBox(width: 10),
                  _buildSelectionButton('Night'),
                  SizedBox(width: 10),
                  _buildSelectionButton('Other'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(String title) {
    final isSelected = selectedPart == title;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        setState(() {
          selectedPart = title;
          widget.onSelectPartOfDay(selectedPart);
        });
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
