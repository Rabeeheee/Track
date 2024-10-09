import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:intl/intl.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:trackit/color/colors.dart';
import 'package:trackit/hive_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HabitScreen extends StatefulWidget {
  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  DateTime _currentDate = DateTime.now();
  bool _isMorningExpanded = false;
  bool _isAfternoonExpanded = false;
  final HiveService _hiveService = HiveService();
  String? username;
  File? _imagePath;
  int _selectedTheme = 0; // 0 for Bright Mode, 1 for Dark Mode

  final List<String> _morningTasks = ['Wake up early', 'Read'];
  final List<String> _afternoonTasks = ['Lunch', 'Take a walk'];

  int _selectedIndex = 0; // Updated to start with the first item

  @override
  void initState() {
    super.initState();
    _updateDate();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    String? storedUsername = await _hiveService.getUsername();
    setState(() {
      username = storedUsername;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
      await _hiveService.saveProfileImagePath(_imagePath!.path);
    } else {
      print('No image selected');
    }
  }

  void _updateDate() {
    setState(() {
      _currentDate = DateTime.now();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ThemeData get _currentTheme {
    return _selectedTheme == 1
        ? ThemeData.dark().copyWith(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(backgroundColor: Colors.black),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(backgroundColor: Colors.white),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _currentTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Habit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Iconify(
                GameIcons.progression,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        drawer: Container(
          width: 250,
          child: Drawer(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    'Hey $username',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imagePath != null
                          ? FileImage(File(_imagePath!.path))
                          : AssetImage('assets/images/default.jpg'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Theme',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RadioListTile(
                    title: Text('Bright Mode'),
                    value: 0,
                    groupValue: _selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        _selectedTheme = value as int;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  RadioListTile(
                    title: Text('Dark Mode'),
                    value: 1,
                    groupValue: _selectedTheme,
                    onChanged: (value) {
                      setState(() {
                        _selectedTheme = value as int;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Date row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) {
                  DateTime date = _currentDate.subtract(
                      Duration(days: _currentDate.weekday - 1 - index));
                  bool isSelected = date.day == _currentDate.day;
                  return Column(
                    children: [
                      Text(
                        DateFormat.E().format(date),
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 4),
                      CircleAvatar(
                        backgroundColor: isSelected ? Colors.blue : Colors.black,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 328,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Must Do',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildTaskRow('Run 2km every morning', 'assets/images/run.jpeg'),
                            SizedBox(height: 20),
                            _buildTaskRow('Drink 2L water every day', 'assets/images/water.jpeg'),
                            SizedBox(height: 20),
                            _buildTaskRow('Take cold shower 2 times a week', 'assets/images/shower.webp'),
                            SizedBox(height: 20),
                            _buildTaskRow('Read and Meditate every day', 'assets/images/read.jpeg'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTaskSection('Morning', _morningTasks, _isMorningExpanded, (value) {
                          setState(() {
                            _isMorningExpanded = value;
                          });
                        }),
                        _buildTaskSection('Afternoon', _afternoonTasks, _isAfternoonExpanded, (value) {
                          setState(() {
                            _isAfternoonExpanded = value;
                          });
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
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
              icon: Icon(Icons.more_horiz_outlined),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildTaskRow(String task, String imagePath) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 10),
        Text(
          task,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTaskSection(String title, List<String> tasks, bool isExpanded, Function(bool) onToggle) {
    return Expanded(
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => onToggle(!isExpanded),
              ),
            ),
            if (isExpanded)
              ...tasks.map((task) => ListTile(title: Text(task))).toList(),
          ],
        ),
      ),
    );
  }
}
