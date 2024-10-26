import 'package:hive_flutter/hive_flutter.dart';

part 'calender_modal.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObject {
  @HiveField(0)
  String likeToDo;

  @HiveField(1)
  String Descrition;

  @HiveField(2)
  final String priority;

  @HiveField(3)
  final DateTime date;

  @HiveField(4) 
  bool isCompleted; 

  @HiveField(5)
  final String? id;

  @HiveField(6)
  bool isSelected;

  Task({
    required this.likeToDo,
    required this.Descrition,
    required this.date,
    required this.priority,
    this.isCompleted = false, 
    this.isSelected = false,
    this.id,
  });
}
