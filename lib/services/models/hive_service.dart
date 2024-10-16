import 'package:hive/hive.dart';

class HiveService {
  Future<Box> openBox() async {
    return await Hive.openBox('userBox');


  }

  Future<void> clearbox() async{
    var box = Hive.box('userBox');
    box.clear();
  }

  // Save username
  Future<void> saveUsername(String username) async {
    var box = await openBox();
    await box.put('username', username);
  }

  // Retrieve username
  Future<String?> getUsername() async {
    var box = await openBox();
    return box.get('username');
  }

  // Save profile image path
  Future<void> saveProfileImagePath(String path) async {
    var box = await openBox();
    await box.put('profileImagePath', path);
  }

  // Retrieve profile image path
  Future<String?> getProfileImagePath() async {
    var box = await openBox();
    return box.get('profileImagePath');
  }

  // Save selected avatar path
  Future<void> saveSelectedAvatarPath(String path) async {
    var box = await openBox();
    await box.put('selectedAvatarPath', path);  
  }

  // Retrieve selected avatar path
  Future<String?> getSelectedAvatarPath() async {
    var box = await openBox();
    return box.get('selectedAvatarPath'); 
  }
}
