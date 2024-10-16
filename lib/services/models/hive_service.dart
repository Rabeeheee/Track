import 'package:hive/hive.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/modals.dart';


class HiveService {
  // Open the userBox
  Future<Box> openuserBox() async {
    return await Hive.openBox('userBox');
  }

//to store habits
 Future<Box<AddhabitModal>> openHabitBox() async {
  return await Hive.openBox<AddhabitModal>('habitBox');
}

  

  // Clear the userBox
  Future<void> clearuserbox() async {
    var box = Hive.box('userBox');
    await box.clear();
  }

  // Clear the addhabitbox
  Future<void> clearhabitbox() async {
    var box = Hive.box('addhabitbox');
    await box.clear();
  }

  // Save username in userBox
  Future<void> saveUsername(String username) async {
    var box = await openuserBox();
    await box.put('username', username);
  }

  // Retrieve username from userBox
  Future<String?> getUsername() async {
    var box = await openuserBox();
    return box.get('username');
  }

  // Save profile image path in userBox
  Future<void> saveProfileImagePath(String path) async {
    var box = await openuserBox();
    await box.put('profileImagePath', path);
  }

  // Retrieve profile image path from userBox
  Future<String?> getProfileImagePath() async {
    var box = await openuserBox();
    return box.get('profileImagePath');
  }


  // Update a habit's completion status (toggle between true or false)
 // Update a habit's completion status based on its unique ID
Future<void> updateHabitCompletion(AddhabitModal habit) async {
  var box = await openHabitBox();
  
  // Find the habit by its unique id in the box
  final existingHabitKey = box.keys.firstWhere((key) {
    final storedHabit = box.get(key) as AddhabitModal?;
    return storedHabit?.id == habit.id;
  }, orElse: () => null);

  if (existingHabitKey != null) {
    habit.isCompleted = !habit.isCompleted;  // Toggle the 'isCompleted' value
    await box.put(existingHabitKey, habit);  // Update the habit in the box
  }
}



 Future<dynamic> saveHabit(AddhabitModal habit) async {
  var box = await openHabitBox();
  await box.add(habit);  
}

  Future<List<AddhabitModal>> getAllHabits() async {
    var box = await openHabitBox();
    return box.values.toList();  // Returns a list of all habits
  }



}
