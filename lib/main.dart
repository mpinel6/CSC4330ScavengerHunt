import 'package:flutter/material.dart';
import 'package:scavengerhutn/article_page.dart';

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

class MapImagePage extends StatefulWidget {
  @override
  _MapImagePageState createState() => _MapImagePageState();
}

class _MapImagePageState extends State<MapImagePage> {
  int currentLevel = 0;

  // Positions for button placement at different levels
  final List<Offset> positions = [
    Offset(100, 100),
    Offset(200, 150),
    Offset(300, 250),
  ];

  // Articles corresponding to each level
  final List<Map<String, String>> articles = [
    {
      "image": "images/article1.png",
      "text": "Beyond the towering gates of Patrick F. Taylor Hall, a fortress of knowledge and innovation, lies a passage oft traversed by weary scholars and wandering minds alike. The grand archway beckons all who seek wisdom, but before one may delve into the depths of its scholarly halls, a test of perception must be met.\n\n"
          "At the threshold, the scent of freshly baked bread and the aroma of roasted coffee linger in the air—a merchant’s haven set upon the very entrance to the keep. It is here, within the confines of this bustling outpost, that many weary travelers find solace before embarking upon their academic quests. The merchants of Panera, as they are known, offer sustenance and warmth, a momentary respite before the trials that await.\n\n"
          "To proceed beyond this humble sanctuary, one must recall the **most common fare** sought by scholars and adventurers alike. The offering exchanged more than any other, **found upon the great menu board**, bears a number of great significance. Seek ye the first item, oft chosen, and only then shall the next path be revealed.\n\n"
          "**(Hint: The first item listed on the great menu of Panera is a clue.)**\n\n"
          "Enter the number of this offering and prove thy worth.",
      "code": "101" // Example code based on Panera's top-selling item (e.g., a meal number)
    },
    {"image": "images/article2.png", "text": "This is the second article.", "code": "5678"},
    {"image": "images/article3.png", "text": "This is the final article.", "code": "9012"},
  ];

  Offset get buttonPosition => positions[currentLevel];

  void unlockNextLevel() {
    setState(() {
      if (currentLevel < positions.length - 1) {
        currentLevel++;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Congratulations!"),
            content: Text("You've unlocked all articles!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    });
  }

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
            left: buttonPosition.dx,
            top: buttonPosition.dy,
            child: GestureDetector(
              onTap: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticlePage(
                      articleImage: articles[currentLevel]["image"]!,
                      articleText: articles[currentLevel]["text"]!,
                      correctCode: articles[currentLevel]["code"]!,
                    ),
                  ),
                );
                if (result == true) {
                  unlockNextLevel();
                }
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