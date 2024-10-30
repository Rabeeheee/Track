import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';
import 'package:trackitapp/services/models/progress_modal.dart';

class OverallProgress extends StatefulWidget {
  
  const OverallProgress({super.key});

  @override
  OverallProgressState createState() => OverallProgressState();
}



class OverallProgressState extends State<OverallProgress> {



  Future<double> calculateOverallProgress() async {
    var hiveService = HiveService();
    List<WeeklyProgress> weeklyProgressList = await hiveService.getWeeklyProgress();

    int totalPoints = 0;
    int totalPossiblePoints = 0;

    int daysPassed = DateTime.now().weekday;

    for (var progress in weeklyProgressList) {
      totalPoints += progress.points;
      print('Weekly Points: ${progress.points}, Total Points: $totalPoints');
    }

    totalPossiblePoints = daysPassed * 100;

    if (totalPossiblePoints > 0) {
      double overallProgress = (totalPoints / totalPossiblePoints) * 100;
      print('Overall Progress: $overallProgress%');
      return overallProgress;
    }

    return 0;
  }
  @override
  void initState() {
    super.initState();
    calculateOverallProgress();
    HiveService().getWeeklyProgress();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<double>(
      future: calculateOverallProgress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); 
        } else if (snapshot.hasError) {
          return Text("Error calculating progress"); 
        } else {
          double overallProgress = snapshot.data ?? 0.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Fonts',
                  ),
                ),
              ),
              Card(
                color: themeProvider.themeData.cardColor,
                surfaceTintColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'Overall Progress',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Fonts',
                          fontWeight: FontWeight.bold,
                          color: themeProvider.themeData.splashColor
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 250,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: SfRadialGauge(
                          axes: [
                            RadialAxis(
                              pointers: [
                                RangePointer(
                                  value: overallProgress,
                                  width: 35,
                                  cornerStyle: CornerStyle.bothCurve,
                                  gradient: const SweepGradient(colors: [
                                    Color(0xFF73C5C5),
                                    Color(0xFF009596),
                                    Color(0xFF005F60),
                                  ], stops: [0.1, 0.40, 0.80]),
                                ),
                              ],
                              axisLineStyle: AxisLineStyle(
                                thickness: 35,
                                color: Colors.grey.shade300,
                              ),
                              startAngle: 5,
                              endAngle: 5,
                              showTicks: false,
                              showLabels: false,
                              annotations: [
                                GaugeAnnotation(
                                  widget: Text(
                                    overallProgress.toStringAsFixed(0),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Fonts',
                                      fontSize: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
