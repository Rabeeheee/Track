import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackitapp/pages/tabs/Habit/add_habit_reminder.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/addhabit_modal.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';
import 'dart:math';

class NewHabit extends StatefulWidget {
  final int habitId;
  final String title;
  final String subtitle;
  final String? selectedAvatarPath;
  final String? description;

  const NewHabit({
    super.key,
    required this.habitId,
    required this.title,
    required this.subtitle,
    this.selectedAvatarPath,
    this.description,
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

  bool isEditing = false;

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
  
  if (widget.habitId != 0) { 
    isEditing = true;
    loadHabitById(widget.habitId);
    // _loadSelectedAvatar();
  } else if (widget.title.isNotEmpty && widget.subtitle.isNotEmpty) {
    _titleController.text = widget.title;
    _quoteController.text = widget.subtitle;
    _descriptionController.text = widget.description ?? '';
    selectedAvatar = widget.selectedAvatarPath;
  }
}


  loadHabitById(int habitId) async {
    if (isEditing) {
      AddhabitModal? habit = await _hiveService.getHabitById(habitId);
      setState(() {
        _titleController.text = habit?.name ?? '';
        _quoteController.text = habit?.quote ?? '';
        _descriptionController.text = habit?.description ?? '';
        selectedAvatar = habit?.selectedAvatarPath;
      });
    }
  }

  Future<void> _clearStoredAvatar() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('selectedAvatar');
}

  void _saveHabit() async {
    int habitId = await _generateUniqueId();

    if (widget.habitId == 0) {
      isEditing = false;

      AddhabitModal newHabit = AddhabitModal(
        name: _titleController.text,
        quote: _quoteController.text,
        description: _descriptionController.text,
        selectedAvatarPath: selectedAvatar,
        id: habitId,
      );

      await _hiveService.saveHabit(newHabit);

      setState(() {
        selectedAvatar == null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Habit added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      AddhabitModal updatedHabit = AddhabitModal(
        name: _titleController.text,
        quote: _quoteController.text,
        description: _descriptionController.text,
        selectedAvatarPath: selectedAvatar,
        id: widget.habitId,
      );

      await _hiveService.updateHabit(updatedHabit);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Habit updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<int> _generateUniqueId() async {
    List<AddhabitModal> habits = await _hiveService.getAllHabits();

    if (habits.isEmpty) {
      return 1;
    }

    int? maxId =
        habits.map((habit) => habit.id).reduce((a, b) => a! > b! ? a : b);
    return maxId! + 1;
  }

  Future<void> _loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loadedAvatarBase64 = prefs.getString('selectedAvatar');
    print("Loaded avatar base64 from SharedPreferences: $loadedAvatarBase64");

    if (loadedAvatarBase64 != null) {
      setState(() {
        selectedAvatar = loadedAvatarBase64;
      });
    }
  }

 Future<void> _pickImage() async {
  String? base64Image;
  Uint8List? imageBytes;

  if (kIsWeb) {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      base64Image = base64Encode(bytes);
      imageBytes = bytes;
      print("Picked image for web as base64: $base64Image");
    }
  } else {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      base64Image = base64Encode(bytes);
      imageBytes = bytes;
    }
  }

  if (imageBytes != null) {
    setState(() {
      selectedAvatar = base64Image; 
    });
  }
}

  Future<String> _convertImageToBase64(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();
    return base64Encode(imageBytes); 
  }


  void _randomizeQuote() {
    final randomIndex = Random().nextInt(Quotes.length);
    setState(() {
      _quoteController.text = Quotes[randomIndex];
    });
  }

  void _navigateToReminderScreen() async {
    await _loadSelectedAvatar();

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name cannot be empty"),
                backgroundColor: Colors.red,
),
      );
      return;
    }
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Description cannot be empty'),
                backgroundColor: Colors.red,
),
      );
      return;
    }
    if (_quoteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote cannot be empty'),
                backgroundColor: Colors.red,
),
      );
      return;
    }

    if (selectedAvatar == null || selectedAvatar!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Avatar cannot be empty'),
        backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
        child: SingleChildScrollView(
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
                        ? MemoryImage(base64Decode(selectedAvatar!))
                        : null,
                    child: selectedAvatar == null
                        ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                        : null,
                  ),
                  ),
                  SizedBox(height: 40),
                  _buildTextField(themeProvider, 'Name', _titleController,
                      'Daily Check-in'),
                  SizedBox(height: 10),
                  _buildTextField(themeProvider, 'Description',
                      _descriptionController, 'Description'),
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
              SizedBox(
                height: 10,
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
                        backgroundColor: themeProvider.themeData.primaryColor,
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
        borderRadius: BorderRadius.circular(8),
      ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
