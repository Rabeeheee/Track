// custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackitapp/utils/colors.dart';

class Bottomnav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Bottomnav({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.feather),
          label: 'Habit',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.calendarWeek),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Priority',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.clock),
          label: 'Focus',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_outlined,size: 40,),
          label: 'More',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      iconSize: 30,
      onTap: onItemTapped,
    );
  }
}
