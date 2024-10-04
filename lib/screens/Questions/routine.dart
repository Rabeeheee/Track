import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackit/color/colors.dart';
import 'package:trackit/screens/Questions/result_screen.dart';

class RoutineScreen extends StatefulWidget {
  final List<int> userResponses; // Add this line

  RoutineScreen({required this.userResponses}); // Update constructor

  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}



class _RoutineScreenState extends State<RoutineScreen> {
  double sliderValue = 1.0; // Slider value to select options
  String currentHabit = "Wake up Early"; // Selected habit
  int habitIndex = 0; // Current index of habit

  // Habit data mapping
  Map<String, List<String>> habitOptions = {
    "Wake up Early": ['5AM or earlier', '6AM', '7AM', '8AM', '9AM or later'],
    "Drink Water": ['1L', '2L', '3L', '4L', '5L'],
    "Run": ['1KM', '2KM', '5KM', '10KM', '15KM'],
    "Gym Workout": ['30 min', '45 min', '1 hr', '1.5 hr', '2 hr'],
    "Meditate": ['5 min', '10 min', '15 min', '20 min', '30 min'],
    "Read Books": ['10 pages', '20 pages', '30 pages', '50 pages', '100 pages'],
    "Social Media\nLimit": ['1 hr', '2 hr', '3 hr', '4 hr', '5 hr'],
    "Take Shower": ['1 min', '5 min', '10 min', '15 min', '20 min'],
  };

  // Progress values mapping for each habit
  Map<String, double> habitProgress = {
    "Wake up Early": 0.49,
    "Drink Water": 0.56,
    "Run": 0.63,
    "Gym Workout": 0.7,
    "Meditate": 0.77,
    "Read Books": 0.84,
    "Social Media\nLimit": 0.91,
    "Take Shower": 0.98,
  };

  // List of habits with their icons
  List<Habit> habits = [
    Habit(name: "Wake up Early", icon: FontAwesomeIcons.sun),
    Habit(name: "Drink Water", icon: FontAwesomeIcons.glassWater),
    Habit(name: "Run", icon: FontAwesomeIcons.running),
    Habit(name: "Gym Workout", icon: Icons.sports_gymnastics),
    Habit(name: "Meditate", icon: FontAwesomeIcons.medkit),
    Habit(name: "Read Books", icon: Icons.book),
    Habit(name: "Social Media\nLimit", icon: FontAwesomeIcons.mobile),
    Habit(name: "Take Shower", icon: FontAwesomeIcons.shower),
  ];

  void nextHabit() {
    setState(() {
      if (habitIndex < habits.length - 1) {
        habitIndex++;
      } else {
        // Calculate the ratings
        Map<String, double> ratings = calculateRatings();

        // Navigate to the ResultScreen with calculated ratings
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              ratings: ratings,
              habitResult: currentHabit, // Pass the current habit result
            ),
          ),
        );
        return; // Stop the execution here as we are navigating
      }
      updateCurrentHabit();
    });
  }

  void previousHabit() {
    setState(() {
      habitIndex = (habitIndex - 1 + habits.length) % habits.length;
      updateCurrentHabit();
    });
  }

  void updateCurrentHabit() {
    currentHabit = habits[habitIndex].name;
    sliderValue = 1.0; // Reset slider when changing habit
  }

  Map<String, double> calculateRatings() {
    // Calculate the ratings as percentages based on slider value
    return {
      'overallRating': (sliderValue / 4) * 100,
      'wisdomRating': (sliderValue / 4) * 100,
      'strengthRating': (sliderValue / 4) * 100,
      'focusRating': (sliderValue / 4) * 100,
      'confidenceRating': (sliderValue / 4) * 100,
      'disciplineRating': (sliderValue / 4) * 100,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(15, 255, 255, 255),
              Color.fromARGB(39, 0, 0, 0),
              Color.fromARGB(14, 255, 255, 255),
              Color.fromARGB(39, 0, 0, 0),
              Color.fromARGB(14, 255, 255, 255),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
          child: Column(
            children: [
              Container(
                width: 350,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: habitProgress[currentHabit],
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.secondaryColor),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: previousHabit,
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'What is your goal for $currentHabit?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Display habits in two columns
                      ...List.generate((habits.length / 2).ceil(), (rowIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: habitWidget(rowIndex * 2), // First habit
                              ),
                              if (rowIndex * 2 + 1 < habits.length)
                                SizedBox(width: 50), // Check for second habit
                              Expanded(
                                child: habitWidget(
                                    rowIndex * 2 + 1), // Second habit
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 30),
                      // Display selected habit option
                      Text(
                        habitOptions[currentHabit]![sliderValue.toInt()],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      SizedBox(height: 30),
                      // Slider for selecting value
                      Slider(
                        value: sliderValue,
                        min: 0,
                        max: 4,
                        divisions: 4,
                        onChanged: (newValue) {
                          setState(() {
                            sliderValue = newValue;
                          });
                        },
                        activeColor: AppColors.secondaryColor,
                        inactiveColor: AppColors.grey,
                      ),
                      SizedBox(height: 30),
                      // Confirm button
                      ElevatedButton(
                        onPressed: () {
                          nextHabit();
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          foregroundColor: AppColors.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget habitWidget(int index) {
    if (index >= habits.length)
      return SizedBox(); // Return an empty widget if index is out of range

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          habits[index].icon,
          color: currentHabit == habits[index].name
              ? Colors.white
              : AppColors.grey,
        ),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            habits[index].name,
            style: TextStyle(
              color: currentHabit == habits[index].name
                  ? Colors.white
                  : AppColors.grey,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class Habit {
  final String name;
  final IconData icon;

  Habit({required this.name, required this.icon});
}
