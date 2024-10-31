import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/memory/add_image.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/services/models/memory_model.dart';
import 'dart:io';
import 'package:trackitapp/utils/theme_provider.dart';

class MemoryScreen extends StatefulWidget {
  @override
  _MemoryScreenState createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  List<Folder> folders = [];
  final HiveService _hiveService = HiveService();
  List<Folder> selectedFolders = [];
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loadFolders();
    });
  }
  

  Future<void> loadFolders() async {
    folders = await _hiveService.getAllFolders();
    setState(() {});
  }

  void createFolder() {
    TextEditingController folderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Folder Name'),
          content: TextField(
            controller: folderController,
            decoration: InputDecoration(hintText: "Folder Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newFolderName = folderController.text.trim();

                if (newFolderName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Folder name cannot be empty.')),
                  );
                } else if (folders.any((folder) => folder.name == newFolderName)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Folder name already exists.')),
                  );
                } else {
                  Folder newFolder = Folder(name: newFolderName, imagePaths: []);
                  await _hiveService.saveFolder(newFolder);
                  await loadFolders();
                  Navigator.pop(context);
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete the selected folders?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                for (Folder folder in selectedFolders) {
                  await _hiveService.deleteFolder(folder.name);
                }
                setState(() {
                  loadFolders();
                  isSelectionMode = false;
                  selectedFolders.clear();
                });
                Navigator.pop(context); 
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void toggleSelection(Folder folder) {
    setState(() {
      if (selectedFolders.contains(folder)) {
        selectedFolders.remove(folder);
      } else {
        selectedFolders.add(folder);
      }

      isSelectionMode = selectedFolders.isNotEmpty;
    });

    if (selectedFolders.isEmpty) {
      isSelectionMode = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: (isSelectionMode ? '${selectedFolders.length} Selected' : 'Memories'),
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: showDeleteConfirmationDialog,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: RefreshIndicator(
          onRefresh: loadFolders,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: folders.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  toggleSelection(folders[index]);
                },
                onTap: () {
                  if (isSelectionMode) {
                    toggleSelection(folders[index]); 
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddImage(
                          folder: folders[index],
                          onNewImage: (image) async {
                            setState(() {
                              folders[index].imagePaths.add(image.path);
                            });
                            await _hiveService.saveFolder(folders[index]);
                          },
                        ),
                      ),
                    );
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedFolders.contains(folders[index]) 
                              ? Colors.red 
                              : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedFolders.contains(folders[index])
                                ? Colors.black 
                                : Colors.transparent, 
                            width: 2, 
                          ),
                          image: folders[index].imagePaths.isNotEmpty
                              ? DecorationImage(
                                  image: FileImage(File(folders[index].imagePaths.last)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: folders[index].imagePaths.isEmpty
                            ? Center(child: Icon(Icons.folder, color: Colors.white, size: 50))
                            : null,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      folders[index].name,
                      style: TextStyle(color: themeProvider.themeData.dividerColor),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            onPressed: createFolder,
            backgroundColor: themeProvider.themeData.primaryColor,
            child: Icon(Icons.create_new_folder, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
