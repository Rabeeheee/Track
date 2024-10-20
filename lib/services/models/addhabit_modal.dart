import 'package:hive/hive.dart';

part 'addhabit_modal.g.dart';

@HiveType(typeId: 1)
class AddhabitModal extends HiveObject {

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? quote;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? selectedAvatarPath;

  @HiveField(4)
  String? goalDays; 

  @HiveField(5)
  String? frequency; 

  @HiveField(6)
  String? partOfDay;

  @HiveField(7)
  bool isCompleted = false;  

  @HiveField(8)
  int? id;

  AddhabitModal({
    this.goalDays = 'Forever',
    this.frequency = 'Daily', 
    required this.name,
    this.isCompleted = false,
    required this.id,
    this.partOfDay,
    this.quote,
    this.selectedAvatarPath, 
    String? image, 
    this.description,
  });

  void assignId(int id) {
    this.id = id;
  }
}
