import 'package:flutter/material.dart';
import 'package:trackit/pages/widgets/app_bar.dart';
import 'package:trackit/pages/widgets/bottomnav.dart';
import 'package:trackit/pages/widgets/date_row.dart';
import 'package:trackit/pages/widgets/drawer.dart';
import 'package:trackit/pages/widgets/logout_dialog.dart';

import 'package:trackit/services/models/hive_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:trackit/utils/theme_provider.dart';

class HabitScreen extends StatefulWidget {
  @override
  HabitScreenState createState() => HabitScreenState();
}

class HabitScreenState extends State<HabitScreen> {
  DateTime _currentDate = DateTime.now();
  bool _isMorningExpanded = false;
  bool _isAfternoonExpanded = false;
  bool _isAboutExpanded = false;

  final HiveService _hiveService = HiveService();
  String? username;
  File? _imagePath;

  final List<String> _morningTasks = ['Wake up early', 'Read'];
  final List<String> _afternoonTasks = ['Lunch', 'Take a walk'];
  final List<String> _AboutNotes = [
    'Welcome to Habit\nTracker, your personal\ncompanion for\nbuilding and\nmaintaining positive\nhabits!'
  ];

  int _selectedIndex = 1;

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

  void _showLogoutDialog() {
    return showLogoutDialog(context);
  }

  
  void _onFabPressed() {
    print('Pressed');
   
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.themeData,
      home: Scaffold(
        backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
        appBar: CustomAppBar(),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Date row
                DateRow(currentDate: _currentDate),
                SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      width: 328,
                      height: 300,
                      decoration: BoxDecoration(
                        color: themeProvider.themeData.cardColor,
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
                                  color: themeProvider.themeData.splashColor),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/run.jpeg'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Run 2km every morning',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .themeData.splashColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/water.jpeg'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Drink 2L water everyday',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .themeData.splashColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/shower.webp'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Take cold shower 2 times in a week',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .themeData.splashColor),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/read.jpeg'),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Read and Meditate everyday',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider
                                          .themeData.splashColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    
                    Column(
                      children: [
                        // Morning Section
                        Container(
                          width: 328, 
                          decoration: BoxDecoration(
                            color: themeProvider.themeData.cardColor,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Morning',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: themeProvider
                                              .themeData.splashColor),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${_morningTasks.length}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: themeProvider
                                                  .themeData.splashColor),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              _isMorningExpanded
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: themeProvider
                                                  .themeData.splashColor),
                                          onPressed: () {
                                            setState(() {
                                              _isMorningExpanded =
                                                  !_isMorningExpanded;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (_isMorningExpanded) ...[
                                  SizedBox(height: 10),
                                  for (var task in _morningTasks)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.brown,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            task,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: themeProvider
                                                    .themeData.splashColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Afternoon Section
                        Container(
                          width: 328, 
                          decoration: BoxDecoration(
                            color: themeProvider.themeData.cardColor,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Afternoon',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: themeProvider
                                              .themeData.splashColor),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${_afternoonTasks.length}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: themeProvider
                                                  .themeData.splashColor),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              _isAfternoonExpanded
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: themeProvider
                                                  .themeData.splashColor),
                                          onPressed: () {
                                            setState(() {
                                              _isAfternoonExpanded =
                                                  !_isAfternoonExpanded;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (_isAfternoonExpanded) ...[
                                  SizedBox(height: 10),
                                  for (var task in _afternoonTasks)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.brown,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            task,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: themeProvider
                                                    .themeData.focusColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Add a Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: _onFabPressed,
          backgroundColor: themeProvider.themeData.splashColor,
          child: Icon(Icons.add,size: 35,color: themeProvider.themeData.hoverColor,),
        ),
        bottomNavigationBar: Bottomnav(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
