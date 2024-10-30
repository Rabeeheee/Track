import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/Habit/add_new_habit.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/pages/widgets/habit_def_card.dart';
import 'package:trackitapp/services/models/modals.dart';
import 'package:trackitapp/utils/colors.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class AddDefHabit extends StatelessWidget {

 final int habitId;
    final String title;
    final String subtitle;
    final String? selectedAvatarPath;
    final String? description;
  

  AddDefHabit({
    super.key, 
    required this.habitId, 
    required this.title, 
    required this.subtitle, 
    this.selectedAvatarPath,
    this.description,
    
  });


 final List<Habit> suggestedHabits = [
  Habit(title: "Drink water", subtitle: "Stay moisturized", image: 'assets/images/water.jpeg'),
  Habit(title: "Eat breakfast", subtitle: "Life begins after breakfast", image: 'assets/images/breakfast.jpeg'),
  Habit(title: "Eat fruit", subtitle: "Stay healthier, stay happier", image: 'assets/images/fruit.jpeg'),
  Habit(title: "Early to rise", subtitle: "Get up and be amazing", image: 'assets/images/sun.jpeg'),
  Habit(title: "Learn new words", subtitle: "Small number, big result", image: 'assets/images/words.jpg'),
  Habit(title: "Read", subtitle: "A chapter a day will light your day", image: 'assets/images/read.jpeg'),
  Habit(title: "Early to bed", subtitle: "Dream lofty dreams", image: 'assets/images/sleep.jpeg'),
  Habit(title: "Meditate", subtitle: "Quiet your mind and let the soul speak", image: 'assets/images/meditate.jpeg'),
 ];

  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.themeData,
      home: Scaffold(
        backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
        appBar: CustomAppBar(title: 'Gallery',
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 260),
                child: Text(
                  'Suggested',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Fonts',
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 270),
                child: Container(
                  width: 80,
                  height: 3,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: suggestedHabits.length,
                  itemBuilder: (context, index) {
                    final habit = suggestedHabits[index];
                    return HabitCard(habit: habit,
                 
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => NewHabit(
                         habitId: 0, 
                         title: '',
                        subtitle: '',))
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Create a new habit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.themeData.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
