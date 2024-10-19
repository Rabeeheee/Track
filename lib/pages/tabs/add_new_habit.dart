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
    final int habitId;
    final String title;
    final String subtitle;
  

  const NewHabit({
    super.key, required this.habitId, required this.title, required this.subtitle, 
    
  });

  @override
  State<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final HiveService _hiveService = HiveService();

  // ignore: non_constant_identifier_names
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

  String? selectedAvatar;

  @override
  void initState() {
    super.initState();
    _loadSelectedAvatar();
    loadHabitById(widget.habitId);
  }

  loadHabitById(habitId)async{
    AddhabitModal? habit = await _hiveService.getHabitById(habitId);
    setState(() {
    _titleController.text = habit?.name as String;
    _quoteController.text = habit?.quote as String;
    _descriptionController.text = habit?.description as String;
    habit?.selectedAvatarPath;
    habit?.partOfDay;
    });
  }

  updateHabit(habitId) async{ 
    AddhabitModal updatedModal = AddhabitModal(
      name: _titleController.text, 
      quote: _quoteController.text,
      description: _descriptionController.text,
      id: habitId
      );

      await _hiveService.updateHabit(updatedModal);
  }



  Future<void> _loadSelectedAvatar() async {
    if (selectedAvatar == null ) {
      selectedAvatar = 'assets/images/read.jpeg';
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedAvatar = pickedFile.path;
      });
    }
  }

  void _randomizeQuote() {
    final randomIndex = Random().nextInt(Quotes.length);
    setState(() {
      _quoteController.text = Quotes[randomIndex];
    });
  }

  void _navigateToReminderScreen() async {
    if (_titleController.text.isNotEmpty && _quoteController.text.isNotEmpty) {
      await _loadSelectedAvatar();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddHabitReminder(
            title: _titleController.text,
            quote: _quoteController.text,
            image: selectedAvatar,
            habitId: widget.habitId, 
            description: _descriptionController.text,
            
            
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and Quote cannot be empty")),
      );
    }
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
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                   backgroundImage: selectedAvatar != null
    ? FileImage(File(selectedAvatar!))
    : AssetImage('assets/images/read.jpeg') as ImageProvider,
    

                    child: selectedAvatar == null
                        ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(height: 40),
                _buildTextField(
                    themeProvider, 'Name', _titleController, 'Daily Check-in'),
                     _buildTextField(
                    themeProvider, 'Description', _descriptionController, 'Description'),
                SizedBox(height: 10),
                _buildTextField(
                  themeProvider,
                  'Quote',
                  _quoteController,
                  'Believe in yourself.',
                  iconButton: IconButton(
                    onPressed: _randomizeQuote,
                    icon: Icon(Icons.replay_outlined,
                        size: 20, color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _navigateToReminderScreen,
                    child: Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Fonts'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeProvider().themeData.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildTextField(ThemeProvider themeProvider, String label,
      TextEditingController controller, String hintText,
      {Widget? iconButton}) {
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
