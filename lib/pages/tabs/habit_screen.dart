import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:trackitapp/pages/tabs/add_def_habit.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';
import 'package:trackitapp/pages/widgets/date_row.dart';
import 'package:trackitapp/pages/widgets/drawer.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:trackitapp/utils/colors.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class HabitScreen extends StatefulWidget {
  @override
  HabitScreenState createState() => HabitScreenState();
}

class HabitScreenState extends State<HabitScreen> {
  DateTime _currentDate = DateTime.now();
  bool _isMorningExpanded = false;
  bool _isAfternoonExpanded = false;
  bool _isNightExpanded = false;
  bool _isOtherExpanded = false;

  final HiveService _hiveService = HiveService();
  String? username;
  File? _imagePath;

  // List to store categorized habits
  List<AddhabitModal> _morningHabits = [];
  List<AddhabitModal> _afternoonHabits = [];
  List<AddhabitModal> _nightHabits = [];
  List<AddhabitModal> _otherHabits = [];

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _updateDate();
    _fetchUsername();
    _loadHabits();
  }

  Future<void> _fetchUsername() async {
    String? storedUsername = await _hiveService.getUsername();
    setState(() {
      username = storedUsername;
    });
  }

  Future<void> _loadHabits() async {
    List<AddhabitModal> allHabits = await _hiveService.getAllHabits();
    setState(() {
      _morningHabits = allHabits.where((habit) => habit.partOfDay == 'Morning').toList();
      _afternoonHabits = allHabits.where((habit) => habit.partOfDay == 'Afternoon').toList();
      _nightHabits = allHabits.where((habit) => habit.partOfDay == 'Night').toList();
      _otherHabits = allHabits.where((habit) => habit.partOfDay == 'Other').toList();
    });
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.themeData,
      home: Scaffold(
        backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'Habit',
          actions: [
            IconButton(
              onPressed: () {},
              icon: Iconify(
                GameIcons.progression,
                color: themeProvider.themeData.canvasColor,
              ),
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: themeProvider.themeData.canvasColor,
                ),
              );
            }),
          ],
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Date row
                DateRow(currentDate: _currentDate),
                SizedBox(height: 20),
                
                      Container(
                      
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
                            SizedBox(height: 20,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    
                    SizedBox(height: 10),
                Column(
                  children: [
                    // Morning Section
                    _buildHabitSection(
                      title: 'Morning',
                      habits: _morningHabits,
                      isExpanded: _isMorningExpanded,
                      onExpand: () {
                        setState(() {
                          _isMorningExpanded = !_isMorningExpanded;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Afternoon Section
                    _buildHabitSection(
                      title: 'Afternoon',
                      habits: _afternoonHabits,
                      isExpanded: _isAfternoonExpanded,
                      onExpand: () {
                        setState(() {
                          _isAfternoonExpanded = !_isAfternoonExpanded;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Night Section
                    _buildHabitSection(
                      title: 'Night',
                      habits: _nightHabits,
                      isExpanded: _isNightExpanded,
                      onExpand: () {
                        setState(() {
                          _isNightExpanded = !_isNightExpanded;
                        });
                      },
                    ),
                    SizedBox(height: 10),

                    // Other Section
                    _buildHabitSection(
                      title: 'Other',
                      habits: _otherHabits,
                      isExpanded: _isOtherExpanded,
                      onExpand: () {
                        setState(() {
                          _isOtherExpanded = !_isOtherExpanded;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Add a Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddDefHabit(),
              ),
            );
          },
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.add, size: 35, color: Colors.white),
        ),
        bottomNavigationBar: Bottomnav(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildHabitSection({
    required String title,
    required List<AddhabitModal> habits,
    required bool isExpanded,
    required VoidCallback onExpand,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: themeProvider.themeData.splashColor),
                ),
                Row(
                  children: [
                    Text(
                      '${habits.length}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: themeProvider.themeData.splashColor),
                    ),
                    IconButton(
                      icon: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: themeProvider.themeData.splashColor,
                      ),
                      onPressed: onExpand,
                    ),
                  ],
                ),
              ],
            ),
            if (isExpanded) ...[
              SizedBox(height: 10),
              for (var habit in habits)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onLongPress: (){},
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: habit.selectedAvatarPath == null
                              ? AssetImage('assets/images/default.jpg')
                              : FileImage(File(habit.selectedAvatarPath!)) as ImageProvider,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name!,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.themeData.splashColor),
                            ),
                            Text(
                              habit.quote ?? '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: themeProvider.themeData.splashColor),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
