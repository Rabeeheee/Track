// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'memory_model.g.dart';

@HiveType(typeId: 5)
class Folder {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> imagePaths;

  Folder({required this.name, required this.imagePaths});
}
