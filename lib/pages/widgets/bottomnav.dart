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
import 'package:trackitapp/utils/theme_provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HabitScreen(
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
      });
    }
  }

  Color _getIconColor(int index) {
    return _selectedIndex == index
        ? Provider.of<ThemeProvider>(context).themeData.brightness ==
                Brightness.dark
            ? Colors.white
            : Colors.black
        : Colors.grey;
  }

  double _getIconSize(int index) {
    return _selectedIndex == index ? 30.0 : 24.0;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => _onItemTapped(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesomeIcons.feather,
                        color: _getIconColor(0), size: _getIconSize(0)),
                    const Text('Habit'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesomeIcons.calendarWeek,
                        color: _getIconColor(1), size: _getIconSize(1)),
                    const Text('Calendar'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.grid_view_rounded,
                        color: _getIconColor(2), size: _getIconSize(2)),
                    const Text('Priority'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesomeIcons.clock,
                        color: _getIconColor(3), size: _getIconSize(3)),
                    const Text('Focus'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _onItemTapped(4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.more_horiz_outlined,
                        size: _getIconSize(4), color: _getIconColor(4)),
                    const Text('More'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
