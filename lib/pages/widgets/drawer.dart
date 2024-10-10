import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker
import 'package:provider/provider.dart';
import 'package:trackit/pages/widgets/about_section.dart';
import 'package:trackit/pages/widgets/logout_dialog.dart';
import 'package:trackit/services/models/hive_service.dart';
import 'package:trackit/utils/theme_provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isAboutExpanded = false;
  String? username ;
  String? imagePath;
  final HiveService _hiveService =HiveService();
  final ImagePicker _picker = ImagePicker(); 

  @override
  void initState(){
    super.initState();
    _fetchUsername();
  }

  void _toggleAboutSection() {
    setState(() {
      _isAboutExpanded = !_isAboutExpanded;
    });
  }

  Future<void> _fetchUsername() async {
    String? storedUsername = await _hiveService.getUsername();
    setState(() {
      username = storedUsername!;
    });
  }

  Future<void> onPickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: Column(
          children: [
            Text(
              'Hey $username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.canvasColor,
                fontFamily: 'Fonts',
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onPickImage, 
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imagePath != null
                    ? FileImage(File(imagePath!))
                    : AssetImage('assets/images/default.jpg') as ImageProvider, 
              ),
            ),
            SizedBox(height: 15),
            
            Row(
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  color: themeProvider.themeData.canvasColor,
                ),
                SizedBox(width: 5),
                Text(
                  'Theme',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeData.canvasColor,
                    fontFamily: 'Fonts',
                  ),
                ),
              ],
            ),
            SwitchListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    themeProvider.themeData.brightness == Brightness.dark
                        ? 'Dark Mode'
                        : 'Bright Mode',
                    style: TextStyle(
                      color: themeProvider.themeData.canvasColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Fonts',
                    ),
                  ),
                ],
              ),
              value: themeProvider.themeData.brightness == Brightness.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: Colors.blue,
              inactiveTrackColor: Colors.grey[400],
              inactiveThumbColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              tileColor: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.blueGrey[700]
                  : Colors.blueGrey[300],
            ),
            SizedBox(height: 15),

            // Notifications section
            Row(
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  color: themeProvider.themeData.canvasColor,
                ),
                SizedBox(width: 5),
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.themeData.canvasColor,
                    fontFamily: 'Fonts',
                  ),
                ),
              ],
            ),
            SizedBox(height: 70),

            // About section
            AboutSection(
              isAboutExpanded: _isAboutExpanded,
              toggleAboutSection: _toggleAboutSection,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showLogoutDialog(context);
              },
              child: Text(
                'Restart',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
