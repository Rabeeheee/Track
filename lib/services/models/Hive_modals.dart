import 'package:hive/hive.dart';


part 'Hive_modals.g.dart';


@HiveType(typeId: 0) 
class UserModel extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String profileImagePath;

  @HiveField(2)
  bool completed;

  UserModel({required this.username, required this.profileImagePath, required this.completed});
}
@HiveType(typeId: 1)
class AvatarModel extends HiveObject {
  @HiveField(0)
  String avatarPath;

  AvatarModel({required this.avatarPath});
}
