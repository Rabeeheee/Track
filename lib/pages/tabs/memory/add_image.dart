import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/memory/image_view.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/services/models/memory_model.dart';
import 'package:trackitapp/utils/theme_provider.dart';

class AddImage extends StatefulWidget {
  final Folder folder;
  final Function(File) onNewImage;

  AddImage({
    required this.folder,
    required this.onNewImage,
  });

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final ImagePicker _picker = ImagePicker();
  List<bool> selectedImages = [];
  final HiveService _hiveService = HiveService();

  @override
  void initState() {
    super.initState();
    selectedImages = List.generate(widget.folder.imagePaths.length, (_) => false);
  }

 

  void addImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      widget.onNewImage(imageFile);
      setState(() {
        selectedImages.add(false);
      });
    }
  }

  void deleteSelectedImage() {
    if (selectedImages.contains(true)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete selected images?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () async {
                  for (int i = selectedImages.length - 1; i >= 0; i--) {
                    if (selectedImages[i]) {
                      String imagePath = widget.folder.imagePaths[i];
                      try {
                        await File(imagePath).delete();
                      } catch (e) {
                        print("Error deleting image file: $e");
                      }
                      setState(() {
                        widget.folder.imagePaths.removeAt(i);
                        selectedImages.removeAt(i);
                      });
                    }
                  }
                  await _hiveService.saveFolder(widget.folder);
                  Navigator.of(context).pop();
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
            await File(path).delete();
            setState(() {
              int index = widget.folder.imagePaths.indexOf(path);
              if (index != -1) {
                widget.folder.imagePaths.removeAt(index);
                selectedImages.removeAt(index); 
              }
            });
            await _hiveService.saveFolder(widget.folder); 
          } catch (e) {
            print("Error deleting image file: $e");
          }
        },
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    int selectedCount = selectedImages.where((isSelected) => isSelected).length;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); 
           
          },
        ),
        title: selectedCount > 0 ? '$selectedCount selected' : widget.folder.name,
        actions: [
          if (selectedCount > 0)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteSelectedImage,
            ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
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
                    image: FileImage(File(widget.folder.imagePaths[index])),
                    fit: BoxFit.cover,
                  ),
                  border: selectedImages[index]
                      ? Border.all(color: Colors.blue, width: 3)
                      : null,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addImage,
        backgroundColor: themeProvider.themeData.primaryColor,
        child: Icon(Icons.add_photo_alternate, color: Colors.white),
      ),
    );
  }
}