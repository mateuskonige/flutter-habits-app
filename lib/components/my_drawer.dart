import 'package:flutter/material.dart';
import 'package:habits_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 96),
                Icon(Icons.rule, size: 48),
                Text("Habits App"),
                SizedBox(height: 48),
                Divider(color: Theme.of(context).colorScheme.secondary),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.nights_stay_outlined),
                    SizedBox(width: 12),
                    Text("Dark Mode"),
                  ],
                ),
                Switch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) => Provider.of<ThemeProvider>(
                    context,
                    listen: false,
                  ).toggleTheme(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
