import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:trackitapp/pages/tabs/add_def_habit.dart';
import 'package:trackitapp/pages/tabs/add_new_habit.dart';
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
  final String name;
  final String quote;
  final String? selectedAvatarPath;

  HabitScreen({
    super.key,
    required this.name,
    required this.quote,
    required this.selectedAvatarPath,
  });

  @override
  HabitScreenState createState() => HabitScreenState();
}

class HabitScreenState extends State<HabitScreen> {
  late Box<AddhabitModal> habitBox;
  DateTime _currentDate = DateTime.now();
  bool _isMorningExpanded = false;
  bool _isAfternoonExpanded = false;
  bool _isNightExpanded = false;
  bool _isOtherExpanded = false;

  final HiveService _hiveService = HiveService();
  String? username;

  List<AddhabitModal> _morningHabits = [];
  List<AddhabitModal> _afternoonHabits = [];
  List<AddhabitModal> _nightHabits = [];
  List<AddhabitModal> _otherHabits = [];

  Set<int> selectedMorningIndex = {};
  Set<int> selectedAfternoonIndex = {};
  Set<int> selectedNightIndex = {};
  Set<int> selectedOtherIndex = {};

  int _selectedIndex = 1;

  bool get isAnyHabitSelected =>
      selectedMorningIndex.isNotEmpty ||
      selectedAfternoonIndex.isNotEmpty ||
      selectedNightIndex.isNotEmpty ||
      selectedOtherIndex.isNotEmpty;

  List<AddhabitModal> get selectedHabits {
    List<AddhabitModal> habits = [
      ...selectedMorningIndex.map((index) => _morningHabits[index]),
      ...selectedAfternoonIndex.map((index) => _afternoonHabits[index]),
      ...selectedNightIndex.map((index) => _nightHabits[index]),
      ...selectedOtherIndex.map((index) => _otherHabits[index]),
    ];
    return habits;
  }

  @override
  void initState() {
    super.initState();
    _updateDate();
    _fetchUsername();
    _loadHabits();
  }

  void updateHabitSection(AddhabitModal habit, String newSection) async {
    setState(() {
      if (habit.partOfDay == 'Morning') {
        _morningHabits.remove(habit);
      } else if (habit.partOfDay == 'Afternoon') {
        _afternoonHabits.remove(habit);
      } else if (habit.partOfDay == 'Night') {
        _nightHabits.remove(habit);
      } else if (habit.partOfDay == 'Other') {
        _otherHabits.remove(habit);
      }

      habit.partOfDay = newSection;

      if (newSection == 'Morning') {
        _morningHabits.add(habit);
      } else if (newSection == 'Afternoon') {
        _afternoonHabits.add(habit);
      } else if (newSection == 'Night') {
        _nightHabits.add(habit);
      } else if (newSection == 'Other') {
        _otherHabits.add(habit);
      }

      _hiveService.saveHabit(habit);
    });
  }

 Future<void> _deleteSelectedHabits() async {
  // Collect habits to delete based on selected indices
  List<AddhabitModal> habitsToDelete = [
    ...selectedMorningIndex.map((index) => _morningHabits[index]),
    ...selectedAfternoonIndex.map((index) => _afternoonHabits[index]),
    ...selectedNightIndex.map((index) => _nightHabits[index]),
    ...selectedOtherIndex.map((index) => _otherHabits[index]),
  ];

  // Delete habits from Hive (persistent storage)
  for (var habit in habitsToDelete) {
    await _hiveService.deleteHabit(habit.id!);
  }

  // Update the UI
  setState(() {
    // Remove habits from the local lists after deleting them from Hive
    _morningHabits.removeWhere((habit) =>
        selectedMorningIndex.contains(_morningHabits.indexOf(habit)));
    _afternoonHabits.removeWhere((habit) =>
        selectedAfternoonIndex.contains(_afternoonHabits.indexOf(habit)));
    _nightHabits.removeWhere(
        (habit) => selectedNightIndex.contains(_nightHabits.indexOf(habit)));
    _otherHabits.removeWhere(
        (habit) => selectedOtherIndex.contains(_otherHabits.indexOf(habit)));

    // Clear the selected indices
    selectedMorningIndex.clear();
    selectedAfternoonIndex.clear();
    selectedNightIndex.clear();
    selectedOtherIndex.clear();
  });
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
      _morningHabits =
          allHabits.where((habit) => habit.partOfDay == 'Morning').toList();
      _afternoonHabits =
          allHabits.where((habit) => habit.partOfDay == 'Afternoon').toList();
      _nightHabits =
          allHabits.where((habit) => habit.partOfDay == 'Night').toList();
      _otherHabits =
          allHabits.where((habit) => habit.partOfDay == 'Other').toList();
    });
  }

  void updateHabitCompletion(AddhabitModal habit) {
    setState(() {
      habit.isCompleted = !habit.isCompleted;
      habit.save();
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

  void _clearSelectedHabits() {
    setState(() {
      selectedMorningIndex.clear();
      selectedAfternoonIndex.clear();
      selectedNightIndex.clear();
      selectedOtherIndex.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);


    print('$isAnyHabitSelected');
    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: isAnyHabitSelected ? '' : 'Habit',
        actions: isAnyHabitSelected
            ? [
                IconButton(
                  onPressed: _deleteSelectedHabits,
                  icon: const Icon(Icons.delete),
                  color: themeProvider.themeData.canvasColor,
                ),
                IconButton(
                  onPressed: () async {
                    if (selectedHabits.isNotEmpty) {
                      final editedHabit = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewHabit(
                            habitId: selectedHabits.first.id!, title: '', subtitle: '',
                          ),
                        ),
                      );

                      if (editedHabit != null) {
                        setState(() {
                          final index = _morningHabits.indexWhere(
                              (habit) => habit.id == editedHabit.id);
                          if (index != -1) {
                            _morningHabits[index] = editedHabit;
                          }

                          final indexAfternoon = _afternoonHabits.indexWhere(
                              (habit) => habit.id == editedHabit.id);
                          if (indexAfternoon != -1) {
                            _afternoonHabits[indexAfternoon] = editedHabit;
                          }

                          final indexNight = _nightHabits.indexWhere(
                              (habit) => habit.id == editedHabit.id);
                          if (indexNight != -1) {
                            _nightHabits[indexNight] = editedHabit;
                          }

                          final indexOther = _otherHabits.indexWhere(
                              (habit) => habit.id == editedHabit.id);
                          if (indexOther != -1) {
                            _otherHabits[indexOther] = editedHabit;
                          }
                        });
                      }
                    }
                  },
                  icon: Icon(Icons.edit,
                      color: themeProvider.themeData.canvasColor),
                ),
              ]
            : [
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
        leading: isAnyHabitSelected
            ? IconButton(
                onPressed: _clearSelectedHabits,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DateRow(currentDate: _currentDate),
              const SizedBox(height: 20),
              _buildMustDoSection(themeProvider),
              const SizedBox(height: 10),

              // Displaying Morning Habits
              _buildHabitSection(
                title: 'Morning',
                habits: _morningHabits,
                selectedIndex: selectedMorningIndex,
                isExpanded: _isMorningExpanded,
                onExpand: () {
                  setState(() {
                    _isMorningExpanded = !_isMorningExpanded;
                  });
                },
                selectedHabits: [],
              ),
              const SizedBox(height: 10),

              // Displaying Afternoon Habits
              _buildHabitSection(
                title: 'Afternoon',
                habits: _afternoonHabits,
                selectedIndex: selectedAfternoonIndex,
                isExpanded: _isAfternoonExpanded,
                onExpand: () {
                  setState(() {
                    _isAfternoonExpanded = !_isAfternoonExpanded;
                  });
                },
                selectedHabits: [],
              ),
              const SizedBox(height: 10),

              // Displaying Night Habits
              _buildHabitSection(
                title: 'Night',
                habits: _nightHabits,
                selectedIndex: selectedNightIndex,
                isExpanded: _isNightExpanded,
                onExpand: () {
                  setState(() {
                    _isNightExpanded = !_isNightExpanded;
                  });
                },
                selectedHabits: [],
              ),
              const SizedBox(height: 10),

              // Displaying Other Habits
              _buildHabitSection(
                title: 'Other',
                habits: _otherHabits,
                selectedIndex: selectedOtherIndex,
                isExpanded: _isOtherExpanded,
                onExpand: () {
                  setState(() {
                    _isOtherExpanded = !_isOtherExpanded;
                  });
                },
                selectedHabits: [],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDefHabit(),
                ),
              );
            },
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.add, size: 35, color: Colors.white),
          ),
        ),
      ),
      bottomNavigationBar: Bottomnav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildMustDoSection(ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 20),
            _buildMustDoItem('assets/images/run.jpeg', 'Run 2km every morning',
                themeProvider),
            const SizedBox(height: 20),
            _buildMustDoItem('assets/images/water.jpeg',
                'Drink 2L water everyday', themeProvider),
            const SizedBox(height: 20),
            _buildMustDoItem('assets/images/shower.webp',
                'Take cold shower 2 times in a week', themeProvider),
            const SizedBox(height: 20),
            _buildMustDoItem('assets/images/read.jpeg',
                'Read and Meditate everyday', themeProvider),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMustDoItem(
      String imagePath, String title, ThemeProvider themeProvider) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeData.splashColor),
        ),
      ],
    );
  }

  Widget _buildHabitSection({
    required String title,
    required List<AddhabitModal> habits,
    required Set<int> selectedIndex,
    required bool isExpanded,
    required VoidCallback onExpand,
    required List<AddhabitModal> selectedHabits,
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
                    color: themeProvider.themeData.splashColor,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${habits.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: themeProvider.themeData.splashColor,
                      ),
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
              const SizedBox(height: 10),
              for (int index = 0; index < habits.length; index++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GestureDetector(
                    onLongPress: () {
                      setState(() {
                        if (!selectedIndex.contains(index)) {
                          selectedIndex.add(index);
                        }
                      });
                    },
                    onTap: () {
                      setState(() {
                        if (selectedIndex.contains(index)) {
                          selectedIndex.remove(index);
                        } else {}
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedIndex.contains(index)
                            ? Colors.grey
                            : themeProvider.themeData.cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: habits[index].isCompleted
                                  ? const AssetImage('assets/images/Tick.png')
                                  : (habits[index].selectedAvatarPath != null)
                                      ? FileImage(File(
                                          habits[index].selectedAvatarPath!))
                                      : const AssetImage(
                                              'assets/images/read.jpeg')
                                          as ImageProvider,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    habits[index].name!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          themeProvider.themeData.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    habits[index].quote ?? "",
                                    style: TextStyle(
                                        color: themeProvider
                                            .themeData.splashColor),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: habits[index].isCompleted,
                              onChanged: (bool? value) {
                                setState(() {
                                  habits[index].isCompleted = value ?? false;
                                  habits[index].save();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ]
          ],
        ),
      ),
    );
  }
}
