import 'dart:io';
import 'package:flutter/material.dart';

class ImageFullScreen extends StatelessWidget {
  final String imagePath;
  final Function(String) onDelete; 

  ImageFullScreen({required this.imagePath, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm Deletion'),
                    content: Text('Are you sure you want to delete this image?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          onDelete(imagePath); 
                          Navigator.of(context).pop(); 
                          Navigator.of(context).pop(); 
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}