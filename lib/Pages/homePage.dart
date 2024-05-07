import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../colors.dart';
import 'package:leadconnectpro/Widgets/widgets.dart';
import 'package:camera/camera.dart';
import 'dart:async';

import '../services/ocr.dart';
import 'contactsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ocrService = OCRService();
  String _extractedText = '';
  final _picker = ImagePicker();
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  Future<void> _scanImage() async {
    print("Attempting to pick image...");
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      print("No image picked.");
      return;
    }
    print("Image picked: ${image.path}");

    try {
      String text = await _ocrService.extractTextFromImage(image);
      print("Extracted text: $text");

      // Navigate to ContactsPage with extracted text
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactsPage(extractedText: text),
        ),
      );
    } catch (e) {
      print("Error extracting text: $e");
      // Optionally, show an error message to the user
    }
  }


  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppsColor.primary,
        centerTitle: true,
        title: Text(''),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: AppsColor.secondary,
              size: 35.0,
            ),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
        iconTheme: IconThemeData(color: AppsColor.secondary, size: 35.0),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle item 2 tap
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                GestureDetector(
              onTap: _scanImage,
              child: Container(
                child: Column(
                  children: [ Icon(
                    Icons.camera_alt_rounded,
                    color: AppsColor.icongrey,
                    size: 150.0,
                  ),
                Text(
                  'Scan Your Card',
                  style: TextStyle(
                      fontSize: 24.0,
                      color: AppsColor.icongrey,
                      fontWeight: FontWeight.bold),
                ),
        ],
      ),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
