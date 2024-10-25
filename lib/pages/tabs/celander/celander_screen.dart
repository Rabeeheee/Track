import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/bottomnav.dart';
import 'package:trackitapp/pages/widgets/date_pickercelender.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class CelanderScreen extends StatefulWidget {
  const CelanderScreen({super.key});

  @override
  State<CelanderScreen> createState() => _CelanderScreenState();
}

class _CelanderScreenState extends State<CelanderScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedPriority = 'Top Priority';
  DateTime? selectedDate;

  String formatDate(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  String getTodayLabel(DateTime date) {
    DateTime today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return 'Today';
    } else {
      return date.day.toString();
    }
  }

  void _showTaskDialog(BuildContext context) {
    DateTime? selectedDateInDialog = selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              child: SizedBox(
                width: 360,
                height: 350,
                child: AlertDialog(
                  backgroundColor: const Color.fromARGB(65, 255, 255, 255),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'What would you like to do.',
                            labelStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .transparent), 
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .transparent), // Transparent border color on focus
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                          value: selectedPriority,
                          items: <String>[
                            'Top Priority',
                            'Necessary',
                            'Regular',
                            'Delete'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPriority = newValue!;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              selectedDateInDialog == null
                                  ? "Today"
                                  : "${DateFormat.yMd().format(selectedDateInDialog!)}",
                            ),
                            IconButton(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      selectedDateInDialog ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  setState(() {
                                    selectedDateInDialog =
                                        picked; // Update local date in dialog
                                  });
                                }
                              },
                              icon: Icon(Icons.calendar_today),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedDate =
                                selectedDateInDialog; // Update main selectedDate
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Fonts',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "${formatDate(_selectedDate)}, ${getTodayLabel(_selectedDate)}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Fonts',
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            DatePickercelender(
              currentDate: _selectedDate,
              onDateSelected: (DateTime date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: () {
              _showTaskDialog(context);
            },
            backgroundColor: themeProvider.themeData.primaryColor,
            child: Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Bottomnav(),
    );
  }
}
