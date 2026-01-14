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
          DrawerHeader(child: Text("Habits App")),
          Row(
            children: [
              Text("Dark Mode"),
              Switch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
