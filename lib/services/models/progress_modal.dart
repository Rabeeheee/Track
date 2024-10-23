import 'package:hive/hive.dart';

part 'progress_modal.g.dart'; 

@HiveType(typeId: 2) 
class WeeklyProgress {
  @HiveField(0)
  final String day; 

  @HiveField(1)
  final int points;

  @HiveField(2)
  final int weeklyPoints;

  

  WeeklyProgress(this.weeklyPoints, {required this.day, required this.points, });
}
