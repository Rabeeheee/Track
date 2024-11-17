import 'package:flutter/material.dart';
import 'package:trackitapp/pages/widgets/Add_Habit/selectable_text.dart';

class FrequencySelectionWidget extends StatelessWidget {
  final String? selectedFrequency;
  final Function(String) onSelectFrequency;

  // ignore: use_super_parameters
  const FrequencySelectionWidget(
      {Key? key,
      required this.selectedFrequency,
      required this.onSelectFrequency,
      z})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelectableTextWidget(
          text: 'Daily',
          isSelected: selectedFrequency == 'Daily',
          onTap: () {
            onSelectFrequency('Daily');
          },
        ),
        const SizedBox(width: 16),
        SelectableTextWidget(
          text: 'Weekly',
          isSelected: selectedFrequency == 'Weekly',
          onTap: () {
            onSelectFrequency('Weekly');
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
