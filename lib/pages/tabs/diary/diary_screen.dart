import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trackitapp/pages/tabs/diary/Diary_detail_screen.dart';
import 'package:trackitapp/pages/tabs/diary/add_diary_screen.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/pages/widgets/customfab.dart';
import 'package:trackitapp/services/models/diary_model.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';

// ignore: use_key_in_widget_constructors
class DiaryScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
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
        appBar: const CustomAppBar(title: 'Choose and Write the Day...'),
        body: Container(
          color: themeProvider.themeData.scaffoldBackgroundColor,
          child: RefreshIndicator(
            onRefresh: _loadDiaryEntries,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    color: themeProvider.themeData.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(0, 0, 0, 0),
                            spreadRadius: 4,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TableCalendar(
                        calendarStyle: CalendarStyle(
                            defaultTextStyle: TextStyle(
                                color: themeProvider.themeData.canvasColor),
                            selectedTextStyle: const TextStyle(
                                color:
                                    Color.fromARGB(255, 255, 255, 255)),
                            selectedDecoration: BoxDecoration(
                              color: themeProvider.themeData.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            outsideTextStyle: const TextStyle(
                                color: Color.fromARGB(255, 87, 87, 87))),
                        headerStyle: HeaderStyle(
                          titleTextStyle: TextStyle(
                              color: themeProvider.themeData.canvasColor),
                          formatButtonVisible: false,
                          leftChevronIcon: Icon(Icons.chevron_left,
                              color: themeProvider.themeData.canvasColor),
                          rightChevronIcon: Icon(Icons.chevron_right,
                              color: themeProvider.themeData.canvasColor),
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
                                    margin: const EdgeInsets.symmetric(vertical: 5),
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
                                            color: themeProvider
                                                .themeData.canvasColor),
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
                            // ignore: unnecessary_to_list_in_spreads
                            .toList(),
                        if (_diaryEntries.isEmpty ||
                            !(_diaryEntries.any((entry) =>
                                isSameDay(entry.date, _selectedDate))))
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/images/no_item.png',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
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
        floatingActionButton: CustomFAB(onPressed: () {
          _navigateToAddEntryScreen(context, _selectedDate);
        }));
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
