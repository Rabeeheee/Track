// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'diary_model.g.dart';

@HiveType(typeId: 4)
class Diary {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String id;

  @HiveField(4)
  final String? selectedImagePath;

  Diary({
    required this.title,
    required this.content,
    required this.date,
    required this.id,
    this.selectedImagePath,
  });
}
