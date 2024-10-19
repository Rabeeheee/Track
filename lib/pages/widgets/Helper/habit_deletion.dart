// import 'package:flutter/material.dart';
// import 'package:trackitapp/services/models/addhabit_modal.dart';
// import 'package:trackitapp/services/models/hive_service.dart';

// class HabitDeletionHandler {
//   final List<AddhabitModal> morningHabits;
//   final List<int> selectedMorningIndex;
//   final List<AddhabitModal> afternoonHabits;
//   final List<int> selectedAfternoonIndex;
//   final List<AddhabitModal> nightHabits;
//   final List<int> selectedNightIndex;
//   final List<AddhabitModal> otherHabits;
//   final List<int> selectedOtherIndex;
//   final VoidCallback onHabitsDeleted;

//   HabitDeletionHandler({
//     required this.morningHabits,
//     required this.selectedMorningIndex,
//     required this.afternoonHabits,
//     required this.selectedAfternoonIndex,
//     required this.nightHabits,
//     required this.selectedNightIndex,
//     required this.otherHabits,
//     required this.selectedOtherIndex,
//     required this.onHabitsDeleted,
//   });

//   void handleDeletedHabits() {
//     morningHabits.removeWhere((habit) =>
//         selectedMorningIndex.contains(morningHabits.indexOf(habit)));
//     afternoonHabits.removeWhere((habit) =>
//         selectedAfternoonIndex.contains(afternoonHabits.indexOf(habit)));
//     nightHabits.removeWhere((habit) =>
//         selectedNightIndex.contains(nightHabits.indexOf(habit)));
//     otherHabits.removeWhere((habit) =>
//         selectedOtherIndex.contains(otherHabits.indexOf(habit)));

//     selectedMorningIndex.clear();
//     selectedAfternoonIndex.clear();
//     selectedNightIndex.clear();
//     selectedOtherIndex.clear();

//     onHabitsDeleted();
//   }
// }

// class HabitDeletionService {
//   final HiveService _hiveService;

//   HabitDeletionService(this._hiveService);

//   Future<void> deleteSelectedHabits({
//     required HabitDeletionHandler handler,
//   }) async {
//     List<AddhabitModal> habitsToDelete = [];

//     habitsToDelete.addAll(handler.morningHabits.where((habit) =>
//         handler.selectedMorningIndex.contains(handler.morningHabits.indexOf(habit))));
//     habitsToDelete.addAll(handler.afternoonHabits.where((habit) =>
//         handler.selectedAfternoonIndex.contains(handler.afternoonHabits.indexOf(habit))));
//     habitsToDelete.addAll(handler.nightHabits.where((habit) =>
//         handler.selectedNightIndex.contains(handler.nightHabits.indexOf(habit))));
//     habitsToDelete.addAll(handler.otherHabits.where((habit) =>
//         handler.selectedOtherIndex.contains(handler.otherHabits.indexOf(habit))));

        

//     for (var habit in habitsToDelete) {
//       await _hiveService.deleteHabit(habit as int);
//     }

//     handler.handleDeletedHabits();
//   }
// }
