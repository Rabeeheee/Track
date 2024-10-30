import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackitapp/pages/tabs/Habit/habit_screen.dart';
import 'package:trackitapp/pages/tabs/Inbox/inbox_screen.dart';
import 'package:trackitapp/pages/tabs/Timer/focus_screen.dart';
import 'package:trackitapp/pages/tabs/celander/celander_screen.dart';
import 'package:trackitapp/pages/tabs/diary/diary_screen.dart';
import 'package:trackitapp/pages/tabs/memory/memory_screen.dart';
import 'package:trackitapp/pages/tabs/priority/priority_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  bool _isMoreSelected = false; // New variable to track "More" selection

  final List<Widget> _screens = [
    HabitScreen(
      name: '',
      quote: '',
      selectedAvatarPath: '',
      isEditing: false,
      habitId: 0,
      description: '',
    ),
    const CelanderScreen(),
    const PriorityScreen(),
    const FocusScreen(),
    DiaryScreen(),
    MemoryScreen(),
    const InboxScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(FontAwesomeIcons.book),
                  title: const Text('Diary'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 4;
                      _isMoreSelected = true; 
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.brain),
                  title: const Text('Memory'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 5;
                      _isMoreSelected = true;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.inbox),
                  title: const Text('Inbox'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 6;
                      _isMoreSelected = true;
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      setState(() {
        _selectedIndex = index;
        _isMoreSelected = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _isMoreSelected ? 4 : _selectedIndex, 
        onTap: _onItemTapped,
        items: const [
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
      ),
    );
  }
}
