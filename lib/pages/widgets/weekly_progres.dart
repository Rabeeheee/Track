import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class WeeklyProgressGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder(
      future: HiveService().calculateWeeklyPoints(),
      builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.amber,
            ),
          );
        }

        var weeklyPoints = snapshot.data!;
        List<BarChartGroupData> barGroups = [];

        List<int> daysOrder = [1, 2, 3, 4, 5, 6, 7]; 

        for (int day in daysOrder) {
          int points = weeklyPoints[day.toString()] ?? 0; 
          double percentage = (points / 100.0) * 100;

          barGroups.add(BarChartGroupData(
            x: day,
            barRods: [
              BarChartRodData(
                toY: percentage,
                width: 20,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 100,
                  color: Colors.grey[200],
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF002F5D),
                    Color(0xFF004B95),
                    Color(0xFF0066CC),
                    Color(0xFF519DE9),
                    Color(0xFF8BC1F7),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ],
          ));
        }

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                maxY: 100,
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        switch (value.toInt()) {
                          case 1:
                            return Text('Mon', style: TextStyle(color: themeProvider.themeData.canvasColor, fontWeight: FontWeight.bold));
                          case 2:
                            return Text('Tue', style: TextStyle(color: themeProvider.themeData.canvasColor, fontWeight: FontWeight.bold));
                          case 3:
                            return Text('Wed', style: TextStyle(color: themeProvider.themeData.canvasColor, fontWeight: FontWeight.bold));
                          case 4:
                            return Text('Thu', style: TextStyle(color: themeProvider.themeData.canvasColor, fontWeight: FontWeight.bold));
                          case 5:
                            return Text('Fri', style: TextStyle(color: themeProvider.themeData.canvasColor, fontWeight: FontWeight.bold));
                          case 6:
                            return Text('Sat', style: TextStyle(color: themeProvider.themeData.canvasColor, fontWeight: FontWeight.bold));
                          case 7:
                            return Text('Sun', style: TextStyle(color: themeProvider.themeData.canvasColor, fontWeight: FontWeight.bold));
                          default:
                            return Text('');
                        }
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: TextStyle(color: themeProvider.themeData.canvasColor, fontWeight: FontWeight.bold),
                        );
                      },
                      interval: 10,
                      reservedSize: 40,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: true),
              ),
            ),
          ),
        );
      },
    );
  }
}
