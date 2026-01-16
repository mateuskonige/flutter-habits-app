import 'package:flutter/material.dart';
import 'package:habits_app/models/app_settings.dart';
import 'package:habits_app/models/habit.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // INITIALIZE DB
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  // Save first date of app startup
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Getfirst date of app startup
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();

    return settings?.firstLaunchDate;
  }

  // CRUD

  // LIST of Habits
  final List<Habit> currentHabits = [];

  // CREATE Habit
  Future<void> addHabit(String habitName) async {
    // create
    final newHabit = Habit()..name = habitName;

    // save
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read db list
    readHabits();
  }

  // READ saved habits from the db
  Future<void> readHabits() async {
    // fetch
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // attach
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();
  }

  // UPDATE - single habit completion
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //  find specific habit
    final existingHabit = await isar.habits.get(id);

    if (existingHabit != null) {
      await isar.writeTxn(() async {
        // if habit is completed -> add the current date to the completedDays list
        if (isCompleted &&
            !existingHabit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();

          existingHabit.completedDays.add(
            DateTime(today.year, today.month, today.day),
          );
        }
        // if habit is NOT completed -> remove the current date from the list
        else {
          existingHabit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        await isar.habits.put(existingHabit);
      });

      // save and re-read
      readHabits();
    }
  }

  // UPDATE - single habit name
  Future<void> updateHabitName(int id, String newHabitName) async {
    final existingHabit = await isar.habits.get(id);

    if (existingHabit != null) {
      await isar.writeTxn(() async {
        existingHabit.name = newHabitName;

        await isar.habits.put(existingHabit);
      });
    }

    readHabits();
  }

  // DELETE - single habit
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    readHabits();
  }
}
