// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'user_modal.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String profileImagePath;

  @HiveField(2)
  bool completed;

  UserModel(
      {required this.username,
      required this.profileImagePath,
      required this.completed});
}
