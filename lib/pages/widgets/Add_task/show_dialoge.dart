import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDialog extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String selectedPriority;
  final DateTime? selectedDate;
  final Function(String) onPriorityChanged;
  final Function(DateTime?) onDateChanged;
  final VoidCallback onSave;

  const TaskDialog({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedPriority,
    required this.selectedDate,
    required this.onPriorityChanged,
    required this.onDateChanged,
    required this.onSave,
  }) : super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  DateTime? selectedDateInDialog;
  late String selectedPriority;

  @override
  void initState() {
    super.initState();
    selectedDateInDialog = widget.selectedDate;
    selectedPriority = widget.selectedPriority;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 290,
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 202, 201, 201),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: widget.titleController,
                decoration: InputDecoration(
                  labelText: 'What would you like to do.',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 123, 122, 122)),
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
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: widget.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 107, 107, 107)),
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
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              DropdownButton<String>(
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
                value: selectedPriority,
                items: <String>['Top Priority', 'Necessary', 'Regular', 'Delete']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPriority = newValue!;
                  });
                  widget.onPriorityChanged(newValue!);
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
                        initialDate: selectedDateInDialog ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDateInDialog = picked;
                        });
                        widget.onDateChanged(picked);
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
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
                    widget.onSave();
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
      ),
    );
  }
}
