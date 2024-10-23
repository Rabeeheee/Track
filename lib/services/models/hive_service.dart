import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/progress_modal.dart';

ValueNotifier<List<WeeklyProgress>> progressListNotifier = ValueNotifier([]);

class HiveService {
  // Open the userBox
  Future<Box> openUserBox() async {
    return await Hive.openBox('userBox');
  }

 

  // Clear the userBox
  Future<void> clearUserBox() async {
    var box = await openUserBox();
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


/////open habit box
   Future<Box<AddhabitModal>> openHabitBox() async {
    return await Hive.openBox('habitBox');
  }

  

  // Open the habitBox with AddhabitModal type
  Future<Box<AddhabitModal>> getHabitsBox() => openHabitBox();



   // Clear the habitBox
  Future<void> clearHabitBox() async {
    var box = await getHabitsBox();
    await box.clear();
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
      // print('Habit ID is null, cannot update');
    }
  }

  // Update habit completion status (just toggle completed state)
  Future<void> updateHabitCompletion(int habitId) async {
    var habit = await getHabitById(habitId);
    if (habit != null) {
      habit.isCompleted = !habit.isCompleted;  
      habit.completedDate = habit.isCompleted ? DateTime.now() : null;
      await updateHabit(habit); 
await updateDailyPoints();
    } 
  }
  // Calculate total points for a specific day
Future<int> calculatePointsForDay(DateTime day) async {
  
  var habits = await getAllHabits();
  int totalHabits = habits.length;

  if(totalHabits ==0 ){
    return 0;
  }

  int points = 0;
  double pointsperHabit = 100 / totalHabits ;

  for (var habit in habits) {
    if (habit.completedDate != null &&
        habit.completedDate!.day == day.day &&
        habit.completedDate!.month == day.month &&
        habit.completedDate!.year == day.year) {
          points += pointsperHabit.toInt();
    }
  }
  return points;
}

// Calculate weekly progress points
Future<Map<String, int>> calculateWeeklyPoints() async {
  Map<String, int> weeklyPoints = {};
  DateTime today = DateTime.now();
  

  for (int i = 0; i < 7; i++) {
    DateTime day = today.subtract(Duration(days: i));
    int points = await calculatePointsForDay(day);
    weeklyPoints[day.weekday.toString()] = points;
  }
 // Save the weekly progress data
  List<WeeklyProgress> weeklyProgressList = weeklyPoints.entries.map((entry) {
  return WeeklyProgress(

    entry.value,
    day: entry.key,
    points: entry.value,
    
  );
}).toList();

//  print("Calling saveWeeklyProgress with data: $weeklyProgressList");

  // List<WeeklyProgress> testList = [
  //   WeeklyProgress(80, day: 'Monday', points: 10),
  //   WeeklyProgress(90, day: 'Tuesday', points: 10)
  // ];
  
  // print("Testing saveWeeklyProgress with test data");
  // await saveWeeklyProgress(testList);

await saveWeeklyProgress(weeklyProgressList);
getWeeklyProgress();

return weeklyPoints;
}

// Calculate the percentage of habits completed each day based on total habits
Future<double> calculateCompletionPercentageForDay(DateTime day) async {
  var habits = await getAllHabits();
  var totalHabits = habits.length;

  if (totalHabits == 0) {
    return 0;
  }

  var completedHabits = habits.where((habit) =>
      habit.completedDate != null &&
      habit.completedDate!.day == day.day &&
      habit.completedDate!.month == day.month &&
      habit.completedDate!.year == day.year).length;

  return (completedHabits / totalHabits) * 100;
}

Future<int> getTotalHabitsForDay(DateTime day) async {
  var habits = await getAllHabits();
  var totalHabits = habits.where((habit) =>
      habit.goalDays != null && 
      habit.isCompleted == false).length;
  return totalHabits;
}

// Function to update daily points after completing a habit
Future<void> updateDailyPoints() async {
    DateTime today = DateTime.now();
    int totalPointsToday = await calculatePointsForDay(today);
    // print("Total Points for Today: $totalPointsToday out of 100");
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

  // weeklyprogress open Box
Future<Box<WeeklyProgress>> openWeeklyProgressBox() async {
  if (Hive.isBoxOpen('weeklyProgressBox')) {
    return Hive.box<WeeklyProgress>('weeklyProgressBox'); 
  } else {
    return await Hive.openBox<WeeklyProgress>('weeklyProgressBox'); 
  }
}

// Save weekly progress
Future<void> saveWeeklyProgress(List<WeeklyProgress> weeklyProgressList) async {
 
   print("saveWeeklyProgress called with list: $weeklyProgressList");
  var box = await openWeeklyProgressBox(); 
  await box.clear(); 
  
  for (var progress in weeklyProgressList) {
    await box.put(progress.day, progress);
  }
//   await saveWeeklyProgress(weeklyProgressList);
// await getWeeklyProgress(); 
  
  // print("Saved Weekly Progress: ${box.values.toList()}");
}

// Retrieve weekly progress
Future<List<WeeklyProgress>> getWeeklyProgress() async {
  var box = await openWeeklyProgressBox();
  var progressList = box.values.toList();

  progressListNotifier.value =List.from(progressList);

  progressListNotifier.notifyListeners();
  
  if (progressList.isEmpty) {
    // print("No progress data available");
  } else {
    print("Weekly Progress List: $progressList");
  }
  
  return progressList;
}





}



