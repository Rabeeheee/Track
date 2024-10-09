import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:trackit/utils/colors.dart';
import 'package:trackit/hive_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart'; // Import Provider
import 'package:trackit/auth/splash_screen.dart';
import 'package:trackit/utils/theme_provider.dart';

class HabitScreen extends StatefulWidget {
  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
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

  @override
  Widget build(BuildContext context) {
    // Get the current theme from the ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.themeData,
      home: Scaffold(
        backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
          title: Text(
            'Habit',
            style: TextStyle(
              color: themeProvider.themeData.canvasColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
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
          automaticallyImplyLeading: false,
        ),
        drawer: Container(
          width: 250,
          child: Drawer(
            backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
            child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: Column(children: [
                  Text(
                    'Hey $username',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeData.canvasColor,
                        fontFamily: 'Fonts'),
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
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: themeProvider.themeData.canvasColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Theme',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeData.canvasColor,
                            fontFamily: 'Fonts'),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          themeProvider.themeData.brightness == Brightness.dark
                              ? 'Dark Mode'
                              : 'Bright Mode',
                          style: TextStyle(
                              color: themeProvider.themeData.canvasColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Fonts'),
                        ),
                      ],
                    ),
                    value:
                        themeProvider.themeData.brightness == Brightness.dark,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey[400],
                    inactiveThumbColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    tileColor:
                        themeProvider.themeData.brightness == Brightness.dark
                            ? Colors.blueGrey[700]
                            : Colors.blueGrey[300],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: themeProvider.themeData.canvasColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeData.canvasColor,
                            fontFamily: 'Fonts'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Column(children: [
                    Row(children: [
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
                            color: themeProvider.themeData.canvasColor),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                                _isAboutExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: themeProvider.themeData.canvasColor),
                            onPressed: () {
                              setState(() {
                                _isAboutExpanded = !_isAboutExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                    ]),
                    if (_isAboutExpanded) ...[
                      SizedBox(height: 10),
                      for (var task in _AboutNotes)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            task,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: themeProvider.themeData.canvasColor),
                          ),
                        ),
                    ],
                  ]),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      showDialog(
                        context: context,
                       builder: (BuildContext context){
                        return AlertDialog(
                          title: Text('Logout Conformation'),
                          content: Text('Do you really want to log out?'),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text('Cancel',style: TextStyle(
                              color: Colors.grey
                            ),)
                            ),
                            TextButton(onPressed: () async {
                              // var box = Hive.box(userBox);
                              // await box.clear();

                              HiveService _hiveService = HiveService();
                              await _hiveService.clearbox();

                              Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(builder: (context)=>SplashScreen()), (Route<dynamic> route)=>false,);

                            }, child: Text('Logout',style: TextStyle(color: Colors.red),))
                          ],
                        );
                       });
                    },
                    child: Text('Logout',style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),),
                  )
                ]
                )
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
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
                            color: themeProvider.themeData.canvasColor,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 4),
                        CircleAvatar(
                          backgroundColor:
                              isSelected ? Colors.blue : Colors.transparent,
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: themeProvider.themeData.canvasColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
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
                                      color:
                                          themeProvider.themeData.splashColor),
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
                                      color:
                                          themeProvider.themeData.splashColor),
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
                                      color:
                                          themeProvider.themeData.splashColor),
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
                                      color:
                                          themeProvider.themeData.splashColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Morning Section
                        Container(
                          width: 159,
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

                        // Afternoon Section
                        Container(
                          width: 159,
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
                                            backgroundColor: Colors.green,
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
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.feather),
              label: 'Habit',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendarWeek),
              label: 'Calender',
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
}
