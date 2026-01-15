import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habits_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime? startDate;
  final Map<DateTime, int>? datasets;
  const MyHeatMap({super.key, required this.startDate, required this.datasets});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.inversePrimary,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: {
        1: isDarkMode ? Colors.green.shade900 : Colors.green.shade100,
        2: isDarkMode ? Colors.green.shade800 : Colors.green.shade200,
        3: isDarkMode ? Colors.green.shade700 : Colors.green.shade300,
        4: isDarkMode ? Colors.green.shade600 : Colors.green.shade400,
        5: isDarkMode ? Colors.green.shade500 : Colors.green.shade500,
      },
    );
  }
}
