// about_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class AboutSection extends StatefulWidget {
  final bool isAboutExpanded;
  final Function toggleAboutSection;

  const AboutSection({
    Key? key,
    required this.isAboutExpanded,
    required this.toggleAboutSection,
  }) : super(key: key);

  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  final List<String> _aboutNotes = [
    'Welcome to Habit\nTracker, your personal\ncompanion for\nbuilding and\nmaintaining positive\nhabits!'
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.star_rate_rounded,
              color: themeProvider.themeData.canvasColor,
            ),
            SizedBox(width: 5),
            Text(
              'About TrackIt',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: themeProvider.themeData.canvasColor,
              ),
            ),
            IconButton(
              icon: Icon(
                widget.isAboutExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: themeProvider.themeData.canvasColor,
              ),
              onPressed: () => widget.toggleAboutSection(),
            ),
          ],
        ),
        if (widget.isAboutExpanded) ...[
          SizedBox(height: 10),
          for (var note in _aboutNotes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                note,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: themeProvider.themeData.canvasColor,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
