import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/diary_model.dart';
import 'dart:io';
import 'package:trackitapp/utils/theme_provider.dart';
import 'package:uuid/uuid.dart';

class AddDiaryScreen extends StatefulWidget {
  final DateTime date;
  final Diary? diary;

  AddDiaryScreen({required this.date, this.diary});

  @override
  _AddDiaryScreenState createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _diaryController = TextEditingController();
  String? _selectedImage;

 @override
void initState() {
  super.initState();
  if (widget.diary != null) {
    _titleController.text = widget.diary!.title;
    _diaryController.text = widget.diary!.content;

    if (widget.diary!.selectedImagePath != null) {
      if (widget.diary!.selectedImagePath!.startsWith('/9j')) {
        _selectedImage = widget.diary!.selectedImagePath;
      } else {
        _convertImageToBase64(widget.diary!.selectedImagePath!).then((base64Image) {
          setState(() {
            _selectedImage = base64Image;
          });
        });
      }
    }
  }
}


  Future<void> _pickImage() async {
  String? base64Image;
  Uint8List? imageBytes;

  if (kIsWeb) {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final bytes = await pickedImage.readAsBytes();
      base64Image = base64Encode(bytes);
      imageBytes = bytes;
    }
  } else {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final bytes = await File(pickedImage.path).readAsBytes();
      base64Image = base64Encode(bytes);
      imageBytes = bytes; 
    }
  }

  if (imageBytes != null) {
    setState(() {
      _selectedImage = base64Image; 
    });
  }
}


  Future<String> _convertImageToBase64(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();
    return base64Encode(imageBytes); 
  }

  void _saveDiaryEntry() async {
    final title = _titleController.text;
    final diaryContent = _diaryController.text;
    final imagePath = _selectedImage;
    final uniqueId = Uuid().v4();

    if (title.isNotEmpty && diaryContent.isNotEmpty) {
      final diary = Diary(
        title: title,
        content: diaryContent,
        date: widget.date,
        id: widget.diary?.id ?? uniqueId,
        selectedImagePath: imagePath,
      );

      final diaryBox = await Hive.openBox<Diary>('diarybox');
      await diaryBox.put(diary.id, diary);

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in the title and diary ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              Icon(Icons.arrow_back, color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        title: (widget.diary == null ? "Write your Day" : "Edit Diary Entry"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date: ${widget.date.toLocal()}".split(' ')[0],
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _titleController,
                style: TextStyle(color: themeProvider.themeData.splashColor),
                decoration: InputDecoration(
                  labelText: "Diary Title",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: themeProvider.themeData.splashColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: themeProvider.themeData.splashColor, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                    border: Border.all(color: Colors.white, width: 2),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(_selectedImage!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Text(
                            'Add an image\nfor your diary',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _diaryController,
                style: TextStyle(color: themeProvider.themeData.splashColor),
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Write your diary here",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide:
                        BorderSide(color: themeProvider.themeData.splashColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(
                        color: themeProvider.themeData.splashColor, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveDiaryEntry,
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 254, 254, 254),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
