import 'package:hive/hive.dart';


part 'addhabit_modal.g.dart';

@HiveType(typeId: 1)
class AddhabitModal extends HiveObject {

  @HiveField(0)
  String? name;

  @HiveField(1)
  String? quote;

  @HiveField(2)
  String? selectedAvatarPath;

  @HiveField(3)
  dynamic goalDays;

  @HiveField(4)
dynamic frequency;

  @HiveField(5)
String? partOfDay;

  @HiveField(6)
  bool isCompleted;  

   @HiveField(7)
  String? id; 

AddhabitModal({
this.goalDays,
 this.frequency,
required this.name,
required this.isCompleted,
required this.id,
 this.partOfDay,
 this.quote,
 this.selectedAvatarPath,
    

});

}


