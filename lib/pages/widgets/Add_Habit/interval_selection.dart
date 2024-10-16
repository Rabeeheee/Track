import 'package:flutter/material.dart';

class IntervalSelectionWidget extends StatefulWidget {
  final int? intervalDays;
  final Function(int) onSelectInterval;

  const IntervalSelectionWidget({
    Key? key,
    required this.intervalDays,
    required this.onSelectInterval,
  }) : super(key: key);

  @override
  _IntervalSelectionWidgetState createState() =>
      _IntervalSelectionWidgetState();
}

class _IntervalSelectionWidgetState extends State<IntervalSelectionWidget> {
  late ScrollController _scrollController;
  late int _selectedIntervalDays;

  @override
  void initState() {
    super.initState();
    _selectedIntervalDays = widget.intervalDays ?? 27;

    _scrollController = ScrollController(
      initialScrollOffset: (_selectedIntervalDays - 1) * 60.0, // Center the selected number
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select Interval Days:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 200, // The height of the scrollable area
          child: _buildScrollableList(),
        ),
      ],
    );
  }

  Widget _buildScrollableList() {
    int itemCount = 30; // We have 30 possible days (1 to 30)
    return ListView.builder(
      controller: _scrollController,
      itemCount: itemCount,
      itemExtent: 60, // Height of each item
      itemBuilder: (context, index) {
        bool isSelected = _selectedIntervalDays == index + 1;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIntervalDays = index + 1; // Update selected day
            });
            widget.onSelectInterval(_selectedIntervalDays);
          },
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.black,
                decoration:
                    isSelected ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
