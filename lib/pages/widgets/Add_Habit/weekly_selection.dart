import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class WeeklySelectionWidget extends StatefulWidget {
  final int? selectedWeekdays;
  final Function(int?) onSelectWeekday;

  // ignore: use_super_parameters
  const WeeklySelectionWidget({
    Key? key,
    required this.selectedWeekdays,
    required this.onSelectWeekday,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WeeklySelectionWidgetState createState() => _WeeklySelectionWidgetState();
}

class _WeeklySelectionWidgetState extends State<WeeklySelectionWidget> {
  late ScrollController _scrollController;
  int _selectedWeekday = 4;

  @override
  void initState() {
    super.initState();

    _selectedWeekday = widget.selectedWeekdays ?? 4;

    _scrollController = ScrollController(
      initialScrollOffset: (_selectedWeekday - 1) * 60.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select How Many Days Per Week:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // ignore: sized_box_for_whitespace
        Container(
          height: 200,
          child: _buildScrollableList(),
        ),
      ],
    );
  }

  Widget _buildScrollableList() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    int itemCount = 7;
    return ListView.builder(
      controller: _scrollController,
      itemCount: itemCount,
      itemExtent: 60,
      itemBuilder: (context, index) {
        bool isSelected = _selectedWeekday == index + 1;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedWeekday = index + 1;
            });
            widget.onSelectWeekday(_selectedWeekday);
          },
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.blue
                    : themeProvider.themeData.splashColor,
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
