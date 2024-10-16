import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/add_habit_reminder.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/services/models/modals.dart';
import 'package:trackitapp/utils/theme_provider.dart';
import 'dart:math';

class NewHabit extends StatefulWidget {
  final String? selectedTitle;
  final String? selectedQuote;
 

  const NewHabit({super.key, this.selectedTitle, this.selectedQuote, });

  @override
  State<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _quoteController = TextEditingController();
  int selectedIndex = 2; // Default selected index

  // Initialize ImagePicker
  final ImagePicker _picker = ImagePicker();
  final HiveService _hiveService = HiveService();

  final List<String> Quotes = [
    'Believe yourself',
    'Dream big. Start small. Act now.',
    'One step at a time.',
    'Make it happen.',
    'Focus on growth.',
    'Embrace the journey.',
    'Consistency is key.',
    'Challenge yourself.',
    'Actions create results.',
    'Trust the process.',
    'Progress over perfection.',
    'Mindset is everything',
    'Less talk, more action.',
  ];

  // Default avatar list
  final List<String> avatar = [
    'assets/avatars/alcohol.png',
    'assets/avatars/cleaning.png',
    'assets/avatars/diary.jpeg',
    'assets/avatars/smoking.png',
    'assets/avatars/workout.png',
  ];

  
  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    _loadSelectedAvatar();

    if (widget.selectedTitle != null) {
      _titleController.text = widget.selectedTitle!;
    }
    if (widget.selectedQuote != null) {
      _quoteController.text = widget.selectedQuote!;
    }
  }

  Future<void> _loadSelectedAvatar() async {
    String? savedAvatarPath = await _hiveService.saveHabit(AddhabitModal(selectedAvatarPath: selectedAvatar));
    if (savedAvatarPath != null) {
      setState(() {
        selectedAvatar = savedAvatarPath; 
      });
    }
  }

  Future<void> _pickImage(int index) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedAvatar = pickedFile.path; 
        avatar[index] = pickedFile.path; 
      });

    
      await _hiveService.saveHabit(AddhabitModal(selectedAvatarPath: selectedAvatar));
    }
  }

  void _randomizeQuote() {
    final randomIndex = Random().nextInt(Quotes.length);
    setState(() {
      _quoteController.text = Quotes[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'New Habit',
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    double size = 50.0;
                    if (index == selectedIndex) {
                      size = 70.0;
                    }
                    return GestureDetector(
                      onTap: () {
                        if (index == selectedIndex) {
                          _pickImage(index);
                        } else {
                          setState(() {
                            selectedIndex = index;
                          });
                        }
                       
                        if (avatar[index] != selectedAvatar) {
                          _hiveService.saveHabit(AddhabitModal(selectedAvatarPath: selectedAvatar));
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: size,
                        width: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: avatar[index].contains('assets/')
                                ? AssetImage(avatar[index]) as ImageProvider
                                : FileImage(File(avatar[index])),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: index == selectedIndex
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blueAccent,
                                    width: 3,
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 40),
                _buildTextField(themeProvider, 'Name', _titleController, 'Daily Check-in'),
                SizedBox(height: 10),
                _buildTextField(themeProvider, 'Quote', _quoteController, 'Believe in yourself.', iconButton: IconButton(
                  onPressed: () {
                   _randomizeQuote();
                  },
                  icon: Icon(Icons.replay_outlined, size: 20, color: Colors.blueAccent),
                )),
              ],
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(_titleController.text.isNotEmpty && _quoteController.text.isNotEmpty){
                      
                      }

                     Navigator.push(context, MaterialPageRoute(builder: (context)=>AddHabitReminder(
                      title: _titleController.text,
                      quote: _quoteController.text,
                      image: selectedAvatar,
                     )));
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Fonts'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeProvider().themeData.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(ThemeProvider themeProvider, String label, TextEditingController controller, String hintText, {Widget? iconButton}) {
  return Container(
    height: 135,
    width: double.infinity,
    decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontFamily: 'Fonts',
                    color: themeProvider.themeData.splashColor,
                    fontWeight: FontWeight.bold),
              ),
              if (iconButton != null) iconButton,
            ],
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color.fromARGB(255, 202, 201, 201),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
               
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                   ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                   )),
          ),
        ],
      ),
    ),
  );
}

}
