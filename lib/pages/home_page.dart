import 'package:flutter/material.dart';
import 'package:habits_app/components/my_drawer.dart';
import 'package:habits_app/components/my_habit_tile.dart';
import 'package:habits_app/database/habit_database.dart';
import 'package:habits_app/models/habit.dart';
import 'package:habits_app/utils/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  // create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Habit"),
        content: TextField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: "Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          MaterialButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              // create
              context.read<HabitDatabase>().addHabit(_textController.text);
              // clear controller
              _textController.clear();
              // popout dialog
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ],
      ),
    );
  }

  void checkHabit(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: _buildHabitList(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildHabitList() {
    // habits db
    final habitDatabase = context.watch<HabitDatabase>();

    // list of habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return MyHabitTile(
          habit: habit,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabit(value, habit),
        );
      },
    );
  }
}
