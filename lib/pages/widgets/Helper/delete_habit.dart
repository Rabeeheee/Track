import 'package:flutter/material.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/hive_service.dart';

class HabitDeletionService {
  final HiveService _hiveService;

  HabitDeletionService(this._hiveService);

  Future<void> deleteSelectedHabits({
    required List<AddhabitModal> morningHabits,
    required List<int> selectedMorningIndex,
    required List<AddhabitModal> afternoonHabits,
    required List<int> selectedAfternoonIndex,
    required List<AddhabitModal> nightHabits,
    required List<int> selectedNightIndex,
    required List<AddhabitModal> otherHabits,
    required List<int> selectedOtherIndex,
    required VoidCallback onHabitsDeleted, 
  }) async {
    List<AddhabitModal> habitsToDelete = [];

    habitsToDelete.addAll(morningHabits.where((habit) =>
        selectedMorningIndex.contains(morningHabits.indexOf(habit))));
    habitsToDelete.addAll(afternoonHabits.where((habit) =>
        selectedAfternoonIndex.contains(afternoonHabits.indexOf(habit))));
    habitsToDelete.addAll(nightHabits.where((habit) =>
        selectedNightIndex.contains(nightHabits.indexOf(habit))));
    habitsToDelete.addAll(otherHabits.where((habit) =>
        selectedOtherIndex.contains(otherHabits.indexOf(habit))));

    for (var habit in habitsToDelete) {
      await _hiveService.deleteHabit(habit as int);
    }

    onHabitsDeleted();
  }
}
