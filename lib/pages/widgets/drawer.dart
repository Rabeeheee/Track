import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/widgets/about_section.dart';
import 'package:trackitapp/pages/widgets/logout_dialog.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isAboutExpanded = false;
  String? username;
  String? imagePath;
  final HiveService _hiveService = HiveService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchProfileImage();
  }

  void _toggleAboutSection() {
    setState(() {
      _isAboutExpanded = !_isAboutExpanded;
    });
  }

  Future<void> _fetchProfileImage() async {
    String? storedImagePath = await _hiveService.getProfileImagePath();
    setState(() {
      imagePath = storedImagePath;
    });
  }

  Future<void> _fetchUsername() async {
    String? storedUsername = await _hiveService.getUsername();
    setState(() {
      username = storedUsername!;
    });
  }

  Future<void> onPickImage() async {
    String? base64Image;
    Uint8List? imageBytes;

    if (kIsWeb) {
      final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (PickedFile != null) {
        final bytes = await PickedFile.readAsBytes();
        base64Image = base64Encode(bytes);
        imageBytes = bytes;
      }
    } else {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await File(pickedFile.path).readAsBytes();
        base64Image = base64Encode(bytes);
        imageBytes = bytes;
      }
    }

    if (imageBytes != null) {
      setState(() {
        imagePath = base64Image;
      });
      await _hiveService.saveProfileImagePath(base64Image!);
    }
  }

  void _showEditDialog() {
    // ignore: no_leading_underscores_for_local_identifiers
    TextEditingController _usernameController =
        TextEditingController(text: username);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final ThemeData theme = themeProvider.themeData;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Row(
            children: [
              Icon(Icons.edit, color: theme.primaryColor),
              const SizedBox(width: 10),
              Text(
                'Edit Username',
                style: TextStyle(
                  color: theme.canvasColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Enter new username',
              labelStyle: TextStyle(
                color: theme.hoverColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
            ),
            style: TextStyle(
              color: theme.canvasColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _updateUsername(_usernameController.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Save',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateUsername(String newUsername) async {
    await _hiveService.saveUsername(newUsername);
    setState(() {
      username = newUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 230,
                    child: Text(
                      'Hey\n $username',
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeData.canvasColor,
                        fontFamily: 'Fonts',
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _showEditDialog();
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onPickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imagePath != null
                      ? MemoryImage(base64Decode(imagePath!))
                      : const AssetImage('assets/images/default.jpg')
                          as ImageProvider,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Icon(
                    Icons.star_rate_rounded,
                    color: themeProvider.themeData.canvasColor,
                  ),
                  const SizedBox(width: 5),
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
              const SizedBox(
                height: 10,
              ),
              Material(
                color: themeProvider.themeData.brightness == Brightness.dark
                    ? Colors.blueGrey[700]
                    : Colors.blueGrey[300],
                borderRadius: BorderRadius.circular(30),
                child: SwitchListTile(
                  title: Text(
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
                  value: themeProvider.themeData.brightness == Brightness.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  tileColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 70),
              AboutSection(
                isAboutExpanded: _isAboutExpanded,
                toggleAboutSection: _toggleAboutSection,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showLogoutDialog(context);
                },
                child: const Text(
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
      ),
    );
  }
}
