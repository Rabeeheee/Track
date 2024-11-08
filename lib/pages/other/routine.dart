
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackitapp/auth/splash_screen2.dart';
import 'package:trackitapp/utils/colors.dart';

class RoutineScreen extends StatefulWidget {
  final List<int> userResponses;
  final Map<String, double> habitProgress;
  final Map<String, double> surveyRatings;

  const RoutineScreen({
    required this.userResponses,
    required this.habitProgress,
    required this.surveyRatings,
  });

  

  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {

  int habitIndex = 0;
  String currentHabit = "Wake up Early";

  List<double> sliderValues = List<double>.filled(8, 1.0);

  @override
  void initState() {
    super.initState();
    updateCurrentHabit();
  }

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

  Map<String, double> getSurveyRatings() {
    return {
      'overallRating': (widget.surveyRatings['overallRating']! / 5) * 100,
      'wisdomRating': (widget.surveyRatings['wisdomRating']! / 5) * 100,
      'strengthRating': (widget.surveyRatings['strengthRating']! / 5) * 100,
      'focusRating': (widget.surveyRatings['focusRating']! / 5) * 100,
      'confidenceRating': (widget.surveyRatings['confidenceRating']! / 5) * 100,
      'disciplineRating': (widget.surveyRatings['disciplineRating']! / 5) * 100,
    };
  }

  void nextHabit() {
    setState(() {

      if (habitIndex < habits.length - 1) {
        habitIndex++;
        updateCurrentHabit();
      } else {
       
        Map<String, double> surveyRatings =
            getSurveyRatings(); 
        Map<String, double> ratings =
            calculateRatings(); 

        
      

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen2(
              surveyRatings: surveyRatings,
              routineRatings: ratings,
            ),
          ),
        );
        return;
      }
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
  }

  Map<String, List<String>> habitToCategories = {
    "Wake up Early": ['disciplineRating'],
    "Drink Water": ['focusRating'],
    "Run": ['strengthRating','confidenceRating'], 
    "Gym Workout": ['strengthRating', 'confidenceRating'],
    "Meditate": ['wisdomRating'],
    "Read Books": ['wisdomRating'],
    "Social Media\nLimit": ['focusRating'],
    "Take Shower": ['disciplineRating'],
  };

  Map<String, double> calculateRatings() {
    double overallRating = 0;
    double wisdomRating = 0;
    double strengthRating = 0;
    double focusRating = 0;
    double confidenceRating = 0;
    double disciplineRating = 0;

    
    for (int i = 0; i < habits.length; i++) {
      double habitValue =
          sliderValues[i];
      double ratingPercentage =
          (habitValue / 4) * 100; 

      overallRating += ratingPercentage;

    
    
      habitToCategories[habits[i].name]?.forEach((category) {
        switch (category) {
          case 'wisdomRating':
            wisdomRating += ratingPercentage;
            break;
          case 'strengthRating':
            strengthRating += ratingPercentage;
            break;
          case 'focusRating':
            focusRating += ratingPercentage;
            break;
          case 'confidenceRating':
            confidenceRating += ratingPercentage;
            break;
          case 'disciplineRating':
            disciplineRating += ratingPercentage;
            break;
        }
      });
    }

    overallRating /= habits.length;
    wisdomRating /= 2;
    strengthRating /= 2;
    focusRating /= 2;
    disciplineRating /= 2;
    confidenceRating /= 2;

    return {
      'overallRating': overallRating,
      'wisdomRating': wisdomRating,
      'strengthRating': strengthRating,
      'focusRating': focusRating,
      'confidenceRating': confidenceRating,
      'disciplineRating': disciplineRating,
    };
  }

  @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
         width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.symmetric(horizontal: 16.0), 
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
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
                  Container(
                    
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                            (habits.length / 2).ceil(), (rowIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20,),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: habitWidget(rowIndex * 2),
                                    ),
                                    if (rowIndex * 2 + 1 < habits.length) 
                                      SizedBox(width: 50),
                                    if (rowIndex * 2 + 1 < habits.length)
                                      Expanded(
                                        child: habitWidget(rowIndex * 2 + 1),
                                      ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: 30),
                            Text(
                              habitOptions[currentHabit]![
                                  sliderValues[habitIndex].toInt()],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            SizedBox(height: 30),
                            Slider(
                              value: sliderValues[habitIndex],
                              min: 0,
                              max: 4,
                              divisions: 4,
                              onChanged: (newValue) {
                                setState(() {
                                  sliderValues[habitIndex] = newValue;
                                });
                              },
                              activeColor: AppColors.secondaryColor,
                              inactiveColor: AppColors.grey,
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                nextHabit();
                                print('working fine');
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget habitWidget(int index) {
  if (index >= habits.length) return SizedBox();

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
