import 'package:hive/hive.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';

class HiveService {
  // Open the userBox
  Future<Box> openUserBox() async {
    return await Hive.openBox('userBox');
  }

    Future<Box<AddhabitModal>> openHabitBox() async {
    return await Hive.openBox('habitBox');
  }

  // Open the habitBox with AddhabitModal type
  Future<Box<AddhabitModal>> getHabitsBox() => openHabitBox();


  // Clear the userBox
  Future<void> clearUserBox() async {
    var box = await openUserBox();
    await box.clear();
  }

  // Clear the habitBox
  Future<void> clearHabitBox() async {
    var box = await getHabitsBox();
    await box.clear();
  }

  // Save username in userBox
  Future<void> saveUsername(String username) async {
    var box = await openUserBox();
    await box.put('username', username);
  }

  // Retrieve username from userBox
  Future<String?> getUsername() async {
    var box = await openUserBox();
    return box.get('username');
  }

  // Save profile image path in userBox
  Future<void> saveProfileImagePath(String path) async {
    var box = await openUserBox();
    await box.put('profileImagePath', path);
  }

  // Retrieve profile image path from userBox
  Future<String?> getProfileImagePath() async {
    var box = await openUserBox();
    return box.get('profileImagePath');
  }

 // Save a new habit with a unique ID
Future<void> saveHabit(AddhabitModal habit) async {
  var box = await getHabitsBox();

  // Assign a unique ID if not already set
  if (habit.id == null || habit.id == 0) {
    habit.id = box.isNotEmpty ? box.keys.cast<int>().last + 1 : 1;
  }

  if (habit.name != null && habit.goalDays != null) {
    await box.put(habit.id, habit); 
  } else {
    print(' {{{{{{{{{{{{{not saving}}}}}}}}}}}}}');
  }
}


  // General method to update a habit
  Future<void> updateHabit(AddhabitModal habit) async {
    var box = await getHabitsBox();
    if (habit.id != null) {
      await box.put(habit.id, habit);
    } else {
      print('Habit ID is null, cannot update');
    }
  }

  // Update habit completion status (just toggle completed state)
  Future<void> updateHabitCompletion(int habitId) async {
    var habit = await getHabitById(habitId);
    if (habit != null) {
      habit.isCompleted = !habit.isCompleted;  
      await updateHabit(habit); 
    } else {
      print('Habit not found with the given ID');
    }
  }

  // Delete habit by ID
 Future<void> deleteHabit(int habitId) async {
  final box = await getHabitsBox();
  await box.delete(habitId); 
  
}

  // Get all habits
  Future<List<AddhabitModal>> getAllHabits() async {
    var box = await getHabitsBox();
    return box.values.toList();
  }

  // Get a specific habit by ID
  Future<AddhabitModal?> getHabitById(int id) async{
    var box = await getHabitsBox();
    return box.get(id);
  }
}
