import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/Add_task/show_dialoge.dart';
import 'package:trackitapp/pages/widgets/customfab.dart';
import 'package:trackitapp/pages/widgets/date_pickercelender.dart';
import 'package:trackitapp/services/models/calender_modal.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';
import 'package:uuid/uuid.dart';

class CelanderScreen extends StatefulWidget {
  const CelanderScreen({super.key});

  @override
  State<CelanderScreen> createState() => _CelanderScreenState();
}

class _CelanderScreenState extends State<CelanderScreen> {
  DateTime _selectedDate = DateTime.now();
  final HiveService _hiveService = HiveService();
  List<Task> tasksForSelectedDate = [];
  bool isAnyTaskSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchTasksForDate(_selectedDate);
  }

  Future<void> _fetchTasksForDate(DateTime date) async {
    List<Task> allTasks = await _hiveService.getAllTasks();
    setState(() {
      tasksForSelectedDate = allTasks.where((task) {
        return task.date.year == date.year &&
            task.date.month == date.month &&
            task.date.day == date.day;
      }).toList();
    });
  }

  void _selectTask(Task task) {
    setState(() {
      isAnyTaskSelected = true;
      for (var task in tasksForSelectedDate) {
        task.isSelected = false;
      }
      task.isSelected = true;
    });
  }

  void _resetSelection() {
    setState(() {
      isAnyTaskSelected = false;
      for (var task in tasksForSelectedDate) {
        task.isSelected = false;
      }
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  String getTodayLabel(DateTime date) {
    DateTime today = DateTime.now();
    return (date.day == today.day &&
            date.month == today.month &&
            date.year == today.year)
        ? 'Today'
        : date.day.toString();
  }

  void _showTaskDialog(BuildContext context, {Task? taskToEdit}) {
    TextEditingController titleController = TextEditingController(
      text: taskToEdit?.likeToDo ?? '',
    );
    TextEditingController descriptionController = TextEditingController(
      text: taskToEdit?.Descrition ?? '',
    );
    String selectedPriority = taskToEdit?.priority ?? 'Top Priority';
    DateTime selectedDate = taskToEdit?.date ?? DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TaskDialog(
          titleController: titleController,
          descriptionController: descriptionController,
          selectedPriority: selectedPriority,
          selectedDate: selectedDate,
          onPriorityChanged: (String newPriority) {
            selectedPriority = newPriority;
          },
          onDateChanged: (DateTime? date) {
            if (date != null) {
              selectedDate = date;
            }
          },
          onSave: () async {
            if (titleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Title cannot be empty!')),
              );
              return;
            }

            if (descriptionController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Description cannot be empty!')),
              );
              return;
            }

            if (taskToEdit == null) {
              String uniqueId = const Uuid().v4();
              Task newTask = Task(
                id: uniqueId,
                likeToDo: titleController.text,
                Descrition: descriptionController.text,
                date: selectedDate,
                priority: selectedPriority,
              );
              await _hiveService.saveTask(newTask);
            } else {
              Task updatedTask = Task(
                id: taskToEdit.id,
                likeToDo: titleController.text,
                Descrition: descriptionController.text,
                date: selectedDate,
                priority: selectedPriority,
              );
              await _hiveService.updateTask(taskToEdit.id!, updatedTask);
            }

            await _fetchTasksForDate(_selectedDate);
            // Navigator.pop(context);
          },
        );
      },
    );
  }

  void _toggleTaskCompletion(Task task) async {
    await _hiveService.updateTaskCompletion(task.id!);
    _fetchTasksForDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: isAnyTaskSelected
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _resetSelection,
                )
              : null,
          title: isAnyTaskSelected
              ? const Text(
                  "Select Task",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fonts',
                  ),
                )
              : Text(
                  "${formatDate(_selectedDate)}, ${getTodayLabel(_selectedDate)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fonts',
                  ),
                ),
          actions: isAnyTaskSelected
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      var selectedTask = tasksForSelectedDate
                          .firstWhere((task) => task.isSelected);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: themeProvider.themeData.cardColor,
                            title: Text(
                              "Confirm Deletion",
                              style: TextStyle(
                                  color: themeProvider.themeData.splashColor),
                            ),
                            content: Text(
                              "Are you sure you want to delete this task?",
                              style: TextStyle(
                                  color: themeProvider.themeData.splashColor),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color:
                                          themeProvider.themeData.splashColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await _hiveService
                                      .deleteTask(selectedTask.id!);
                                  _fetchTasksForDate(_selectedDate);
                                  _resetSelection();
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      var selectedTask = tasksForSelectedDate
                          .firstWhere((task) => task.isSelected);
                      _showTaskDialog(context, taskToEdit: selectedTask);
                    },
                  ),
                ]
              : [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              DatePickercelender(
                currentDate: _selectedDate,
                onDateSelected: (DateTime date) {
                  setState(() {
                    _selectedDate = date;
                  });
                  _fetchTasksForDate(date);
                },
              ),
              Expanded(
                child: tasksForSelectedDate.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no_item.png',
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: tasksForSelectedDate.length,
                        itemBuilder: (context, index) {
                          final task = tasksForSelectedDate[index];
                          return GestureDetector(
                            onLongPress: () => _selectTask(task),
                            onTap: _resetSelection,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: task.isSelected
                                    ? Colors.grey
                                    : themeProvider.themeData.cardColor,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _toggleTaskCompletion(task);
                                    });
                                  },
                                  activeColor:
                                      themeProvider.themeData.primaryColor,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10.0),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.likeToDo,
                                      style: TextStyle(
                                        color:
                                            themeProvider.themeData.splashColor,
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    Text(
                                      task.Descrition,
                                      style: TextStyle(
                                        color:
                                            themeProvider.themeData.splashColor,
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  task.priority,
                                  style: TextStyle(
                                    color: themeProvider.themeData.splashColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: CustomFAB(onPressed: () {
          _showTaskDialog(context);
        }));
  }
}
