import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/diary_model.dart';
import 'package:trackitapp/services/models/memory_model.dart';
import 'package:trackitapp/services/models/progress_modal.dart';
import 'package:trackitapp/services/models/calender_modal.dart'; // Import the Task model

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

  // Open the habitBox
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
    if (habit.id == null || habit.id == 0) {
      habit.id = box.isNotEmpty ? box.keys.cast<int>().last + 1 : 1;
    }
    if (habit.name != null && habit.goalDays != null) {
      await box.put(habit.id, habit);
    } else {
      print('Not saving habit: missing required fields');
    }
  }

  // General method to update a habit
  Future<void> updateHabit(AddhabitModal habit) async {
    var box = await getHabitsBox();
    if (habit.id != null) {
      await box.put(habit.id, habit);
    }
  }

  // Update habit completion status
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

    if (totalHabits == 0) {
      return 0;
    }

    int points = 0;
    double pointsPerHabit = 100 / totalHabits;

    for (var habit in habits) {
      if (habit.completedDate != null &&
          habit.completedDate!.day == day.day &&
          habit.completedDate!.month == day.month &&
          habit.completedDate!.year == day.year) {
        points += pointsPerHabit.toInt();
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

    List<WeeklyProgress> weeklyProgressList = weeklyPoints.entries.map((entry) {
      return WeeklyProgress(
        entry.value,
        day: entry.key,
        points: entry.value,
      );
    }).toList();

    await saveWeeklyProgress(weeklyProgressList);
    getWeeklyProgress();

    return weeklyPoints;
  }

  // Calculate completion percentage for a day
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

  // Get total habits for a day
  Future<int> getTotalHabitsForDay(DateTime day) async {
    var habits = await getAllHabits();
    return habits.where((habit) =>
        habit.goalDays != null &&
        habit.isCompleted == false).length;
  }

  // Function to update daily points after completing a habit
  Future<void> updateDailyPoints() async {
    DateTime today = DateTime.now();
    int totalPointsToday = await calculatePointsForDay(today);
    print("Total Points for Today: $totalPointsToday out of 100");
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
  Future<AddhabitModal?> getHabitById(int id) async {
    var box = await getHabitsBox();
    return box.get(id);
  }

  // Open weekly progress box
  Future<Box<WeeklyProgress>> openWeeklyProgressBox() async {
    if (Hive.isBoxOpen('weeklyProgressBox')) {
      return Hive.box<WeeklyProgress>('weeklyProgressBox');
    } else {
      return await Hive.openBox<WeeklyProgress>('weeklyProgressBox');
    }
  }

  //clear weeklyprogressbox
Future<void> clearWeeklyProgressBox() async {
  var box = await openWeeklyProgressBox();
  await box.clear();
}
    
//   Future<void> clearWeekl() async {
//   var box = await openTaskBox();
//   await box.clear(); 
// }


  // Save weekly progress
  Future<void> saveWeeklyProgress(List<WeeklyProgress> weeklyProgressList) async {
    var box = await openWeeklyProgressBox();
    await box.clear();

    for (var progress in weeklyProgressList) {
      await box.put(progress.day, progress);
await getWeeklyProgress();
      
    }
  }

  // Retrieve weekly progress
  Future<List<WeeklyProgress>> getWeeklyProgress() async {
    var box = await openWeeklyProgressBox();
    var progressList = box.values.toList();
    progressListNotifier.value = List.from(progressList);
    return progressList;
  }

   // Open the task box
  Future<Box<Task>> openTaskBox() async {
    return await Hive.openBox<Task>('taskBox');
  }

   // Clear the habitBox
  Future<void> clearTaskBox() async {
  var box = await openTaskBox();
  await box.clear(); 
}


  // Save a new task
  Future<void> saveTask(Task task) async {
    var box = await openTaskBox();
    await box.put(task.id, task); 
  }

  // Get all tasks
  Future<List<Task>> getAllTasks() async {
    var box = await openTaskBox();
    return box.values.toList();
  }

  // Get a specific task by index
  Future<Task?> getTaskById(String id) async {
    var box = await openTaskBox();
    return box.get(id);
  }

  // Update a task
  Future<void> updateTask(String id, Task task) async {
    var box = await openTaskBox();
    await box.put(id, task); // Update using the unique ID
  }

  // Delete a task by ID
  Future<void> deleteTask(String id) async {
    var box = await openTaskBox();
    await box.delete(id);
  }

  // Update task completion status
Future<void> updateTaskCompletion(String id) async {
  var box = await openTaskBox();
  Task? task = box.get(id);

  if (task != null) {
    task.isCompleted = !task.isCompleted; 
    await box.put(id, task); 
  }
}


 // Open the diary box
Future<Box<Diary>> openDiaryBox() async {
  return await Hive.openBox<Diary>('diarybox');
}

  //clear Diarybox
Future<void> clearDiaryBox() async {
  var box = await openDiaryBox();
  await box.clear();
}

// Save a new diary entry
Future<void> saveDiary(Diary diary) async {
  var box = await openDiaryBox();
  await box.put(diary.id, diary); 
}

// Get all diary entries
Future<List<Diary>> getAllDiaryEntries() async {
  var box = await openDiaryBox();
  return box.values.toList();
}

// Get a specific diary entry by ID
Future<Diary?> getDiaryById(String id) async {
  var box = await openDiaryBox();
  return box.get(id);
}

// Update a diary entry
Future<void> updateDiary(String id, Diary diary) async {
  var box = await openDiaryBox();
  await box.put(id, diary); 
}

// Delete a diary entry by ID
Future<void> deleteDiary(String id) async {
  var box = await openDiaryBox();
  await box.delete(id);
}


  // Open the folderBox
Future<Box<Folder>> openFolderBox() async {
  return await Hive.openBox<Folder>('folderBox');
}

  //clear folderbox
Future<void> clearFolderBox() async {
  var box = await openFolderBox();
  await box.clear();
}

// Save a new folder with image paths
Future<void> saveFolder(Folder folder) async {
  var box = await openFolderBox();
  await box.put(folder.name, folder);
}

// Get all folders
Future<List<Folder>> getAllFolders() async {
  var box = await openFolderBox();
  return box.values.toList();
}

// Delete a folder by name and remove its images
Future<void> deleteFolder(String folderName) async {
  var box = await openFolderBox();
  
  // Retrieve the folder to delete its images
  Folder? folder = box.get(folderName);
  if (folder != null) {
    for (var imagePath in folder.imagePaths) {
      // Your image deletion logic here
      // If you want to delete images from the device, you can use File(imagePath).delete();
    }
    
    await box.delete(folderName); 
  }
}

}

 