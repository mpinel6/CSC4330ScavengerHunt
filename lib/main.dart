import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Unlock App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapImagePage(),
    );
  }
}

class MapImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Unlock App')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/map_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 250,
            top: 250,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CodeUnlockPage()),
                );
              },
              child: Image.asset(
                'images/button_image.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CodeUnlockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Unlock Code')),
      body: Center(child: Text('Code Unlock Page')),
    );
  }
}
