import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/Habit/add_new_habit.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class HabitDetail extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? selectedAvatarPath;
  final String description;
final int? habitId;

  const HabitDetail({
    super.key,
    required this.title,
    required this.subtitle,
    this.selectedAvatarPath, 
    required this.description, 
     required this.habitId,
  });
  
 Future<void> _deleteHabit(BuildContext context) async {
    final hiveService = HiveService();

    
    await hiveService.deleteHabit(habitId!);
    
    Navigator.pop(context); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Habit deleted successfully!"),
      backgroundColor: Colors.grey,
      ),
    );
  }
  

  @override
  

  
  Widget build(BuildContext context) {
    
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Habit Details',
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context)=>NewHabit(
                habitId: habitId!, 
                title: title, 
                subtitle: subtitle,
                selectedAvatarPath: selectedAvatarPath,
                description: description,)
            
            )
            );
          }, icon: Icon(Icons.edit)),
          IconButton(onPressed: () async {
            final shouldDelete = await showDialog<bool>(
              context: context, 
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Delete Habit'),
                  content: Text('Are you sure you want to delete this Habit?'),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context, false);
                    }, child: Text('Cancel')),
                    TextButton(onPressed: (){
                      Navigator.pop(context, true);
                    }, child: Text('Delete'))
                  ],
                );
              });

              if(shouldDelete == true){
                _deleteHabit(context);
              }
          }, 
          icon: Icon(Icons.delete),
          ),
        ],
      ),
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                   MemoryImage(base64Decode(selectedAvatarPath!))
                 
            ),
            SizedBox(height: 20),
            
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.primaryColor,
              ),
            ),
            SizedBox(height: 10),
    
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.themeData.splashColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

             Text(
            description,
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.themeData.splashColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
