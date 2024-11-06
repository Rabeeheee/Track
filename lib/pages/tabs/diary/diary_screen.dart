import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trackitapp/pages/tabs/diary/Diary_detail_screen.dart';
import 'package:trackitapp/pages/tabs/diary/add_diary_screen.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/diary_model.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Diary> _diaryEntries = [];
  final HiveService _hiveService = HiveService();

  @override
  void initState() {
    super.initState();
    _loadDiaryEntries();
  }

  Future<void> _loadDiaryEntries() async {
    _diaryEntries = await _hiveService.getAllDiaryEntries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Choose and Write the Day...'),
      body: Container(
        color: themeProvider.themeData.scaffoldBackgroundColor,
        child: RefreshIndicator(
          onRefresh: _loadDiaryEntries,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Card(
                  color: themeProvider.themeData.scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      calendarStyle: CalendarStyle(
                        // defaultTextStyle: TextStyle(color: Colors.black),
                        // todayTextStyle: TextStyle(color: Colors.black),
                        // selectedTextStyle: TextStyle(color: Colors.white),
                        selectedDecoration: BoxDecoration(
                          color: themeProvider.themeData.primaryColor,
                          shape: BoxShape.circle, // Change shape to circle
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        // titleTextStyle: TextStyle(color: Colors.black),
                        formatButtonVisible: false,
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: Colors.black),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Colors.black),
                      ),
                      focusedDay: _selectedDate,
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      calendarFormat: CalendarFormat.month,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month'
                      },
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDate, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                          _loadDiaryEntries();
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ..._diaryEntries
                          .where(
                              (entry) => isSameDay(entry.date, _selectedDate))
                          .map((entry) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiaryDetailScreen(
                                        diary: entry,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: themeProvider.themeData.cardColor,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  child: ListTile(
                                    title: Text(
                                      entry.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${entry.date.day}/${entry.date.month}/${entry.date.year}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    leading: Icon(Icons.book,
                                        color: themeProvider
                                            .themeData.primaryColor),
                                    trailing: Icon(Icons.arrow_forward,
                                        color: themeProvider
                                            .themeData.primaryColor),
                                  ),
                                ),
                              ))
                          .toList(),
                      if (_diaryEntries.isEmpty ||
                          !(_diaryEntries.any(
                              (entry) => isSameDay(entry.date, _selectedDate))))
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "No Diary for this date",
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddEntryScreen(context, _selectedDate);
        },
        backgroundColor: themeProvider.themeData.primaryColor,
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }

  void _navigateToAddEntryScreen(BuildContext context, DateTime date) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDiaryScreen(date: date),
      ),
    );
    _loadDiaryEntries();
  }
}