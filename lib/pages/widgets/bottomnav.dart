import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/Habit/habit_screen.dart';
import 'package:trackitapp/pages/tabs/Inbox/inbox_screen.dart';
import 'package:trackitapp/pages/tabs/Timer/focus_screen.dart';
import 'package:trackitapp/pages/tabs/celander/celander_screen.dart';
import 'package:trackitapp/pages/tabs/diary/diary_screen.dart';
import 'package:trackitapp/pages/tabs/memory/memory_screen.dart';
import 'package:trackitapp/pages/tabs/priority/priority_screen.dart';
import 'package:trackitapp/utils/colors.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomnavState createState() => _BottomnavState();
}

class _BottomnavState extends State<BottomNav> {
  int selectedIndex = 0;
  bool isExpanded = false;

  final List<Widget> _screens = [
    HabitScreen(name: '', quote: '', selectedAvatarPath: '', isEditing: false, habitId: 0, description: ''),
    CelanderScreen(),
    PriorityScreen(),
    FocusScreen(),
    // InboxScreen(),
    // MemoryScreen(),
    // DiaryScreen(),
  ];
  

  void onItemTapped(int index) {
    if (index == 4) {
      setState(() {
        isExpanded = !isExpanded;
      });
    } else {
      setState(() {
        if (isExpanded) {
          if (index == 0) {
            selectedIndex = 5; 
          } else if (index == 1) {
            selectedIndex = 6; 
          } else if (index == 2) {
            selectedIndex = 4;
          }
          isExpanded = false;
        } else {
          selectedIndex = index; 
        }
      });

      if (selectedIndex >= 0 && selectedIndex < _screens.length) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => _screens[selectedIndex]),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isExpanded)
          BottomNavigationBar(
            backgroundColor: themeProvider.themeData.canvasColor,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.brain),
                label: 'Memory',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Diary',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inbox),
                label: 'Inbox',
              ),
            ],
            currentIndex: 0, 
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            iconSize: 30,
            onTap: onItemTapped,
          ),
        BottomNavigationBar(
          backgroundColor: AppColors.primaryColor,
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
              icon: Icon(Icons.more_horiz_outlined, size: 40),
              label: 'More',
            ),
          ],
          currentIndex: selectedIndex < 5 ? selectedIndex : 0, 
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          iconSize: 30,
          onTap: onItemTapped,
        ),
      ],
    );
  }
}
