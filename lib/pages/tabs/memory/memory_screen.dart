import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackitapp/pages/tabs/memory/add_image.dart';
import 'package:trackitapp/pages/widgets/app_bar.dart';
import 'package:trackitapp/pages/widgets/customfab.dart';
import 'package:trackitapp/services/models/hive_service.dart';
import 'package:trackitapp/services/models/memory_model.dart';
import 'package:trackitapp/utils/theme_provider.dart';

// ignore: use_key_in_widget_constructors
class MemoryScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
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
          title: const Text('Enter Folder Name'),
          content: TextField(
            controller: folderController,
            decoration: const InputDecoration(hintText: "Folder Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newFolderName = folderController.text.trim();

                if (newFolderName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Folder name cannot be empty.')),
                  );
                } else if (folders
                    .any((folder) => folder.name == newFolderName)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Folder name already exists.')),
                  );
                } else {
                  Folder newFolder =
                      Folder(name: newFolderName, imagePaths: []);
                  await _hiveService.saveFolder(newFolder);
                  await loadFolders();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
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
          title: const Text('Delete Confirmation'),
          content: const Text(
              'Are you sure you want to delete the selected folders?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
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
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Delete'),
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
          title: (isSelectionMode
              ? '${selectedFolders.length} Selected'
              : 'Memories'),
          actions: isSelectionMode
              ? [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: showDeleteConfirmationDialog,
                  ),
                ]
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: folders.isEmpty
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
              : RefreshIndicator(
                  onRefresh: loadFolders,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double screenWidth = constraints.maxWidth;
                      int crossAxisCount = (screenWidth / 150).floor();
                      double childAspectRatio = 1.0;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
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
                                          folders[index].imagePaths.add(image);
                                        });
                                        await _hiveService
                                            .saveFolder(folders[index]);
                                      },
                                    ),
                                  ),
                                ).then((_) {
                                  loadFolders();
                                });
                              }
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedFolders
                                              .contains(folders[index])
                                          ? Colors.red
                                          : Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: selectedFolders
                                                .contains(folders[index])
                                            ? themeProvider
                                                .themeData.canvasColor
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                      image: folders[index]
                                              .imagePaths
                                              .isNotEmpty
                                          ? DecorationImage(
                                              image: MemoryImage(base64Decode(
                                                  folders[index]
                                                      .imagePaths
                                                      .last)),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: folders[index].imagePaths.isEmpty
                                        ? const Center(
                                            child: Icon(Icons.folder,
                                                color: Colors.white, size: 50))
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  folders[index].name,
                                  style: TextStyle(
                                      color:
                                          themeProvider.themeData.dividerColor),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
        floatingActionButton: CustomFAB(onPressed: createFolder));
  }
}
