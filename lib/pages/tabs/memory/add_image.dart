import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/memory/image_view.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/pages/widgets/customfab.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/services/models/memory_model.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class AddImage extends StatefulWidget {
  final Folder folder;
  final Function(String) onNewImage;

  // ignore: use_key_in_widget_constructors
  const AddImage({
    required this.folder,
    required this.onNewImage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final ImagePicker _picker = ImagePicker();
  List<bool> selectedImages = [];
  final HiveService _hiveService = HiveService();

  @override
  void initState() {
    super.initState();
    selectedImages =
        List.generate(widget.folder.imagePaths.length, (_) => false);
  }

  Future<void> addImage() async {
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
        widget.folder.imagePaths
            .add(base64Image!); // Add new image to the folder
        selectedImages.add(false);
      });
      await _hiveService.saveFolder(widget.folder); // Save changes to storage
    }
  }

  void deleteSelectedImage() {
    if (selectedImages.contains(true)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete selected images?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () async {
                  for (int i = selectedImages.length - 1; i >= 0; i--) {
                    if (selectedImages[i]) {
                      setState(() {
                        widget.folder.imagePaths.removeAt(i);
                        selectedImages.removeAt(i);
                      });
                    }
                  }
                  await _hiveService.saveFolder(widget.folder);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();

                  if (widget.folder.imagePaths.isEmpty) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  void viewImageFullScreen(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageFullScreen(
          imagePath: imagePath,
          onDelete: (String path) async {
            try {
              setState(() {
                int index = widget.folder.imagePaths.indexOf(path);
                if (index != -1) {
                  widget.folder.imagePaths.removeAt(index);
                  selectedImages.removeAt(index);
                }
              });
              await _hiveService.saveFolder(widget.folder);
            } catch (e) {
              // ignore: avoid_print
              print("Error deleting image file: $e");
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final themeProvider = Provider.of<ThemeProvider>(context);
    int selectedCount = selectedImages.where((isSelected) => isSelected).length;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title:
            selectedCount > 0 ? '$selectedCount selected' : widget.folder.name,
        actions: [
          if (selectedCount > 0)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: deleteSelectedImage,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.folder.imagePaths.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/no_item.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  int crossAxisCount = (screenWidth / 120).floor();
                  double childAspectRatio =
                      screenWidth / (crossAxisCount * 120);

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: widget.folder.imagePaths.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          setState(() {
                            selectedImages[index] = true;
                          });
                        },
                        onTap: () {
                          viewImageFullScreen(widget.folder.imagePaths[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: MemoryImage(base64Decode(
                                  widget.folder.imagePaths[index])),
                              fit: BoxFit.cover,
                            ),
                            border: selectedImages[index]
                                ? Border.all(color: Colors.blue, width: 3)
                                : null,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: CustomFAB(onPressed: addImage),
    );
  }
}
