

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

  Task({
    required this.likeToDo, 
    required this.Descrition,
    required this.date, 
    required this.priority
    });
}