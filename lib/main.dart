import 'package:flutter/material.dart';
import 'package:scavengerhutn/article_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PFT Scavenger Hunt',
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
    Offset(150, 260),
    Offset(420, 240),
    Offset(1350, 240),
  ];

  // Articles corresponding to each level
  final List<Map<String, String>> articles = [
    {
      "image": "images/article1.png",
      "text": "     Beyond the towering gates of Patrick F. Taylor Hall, a fortress of knowledge and innovation, lies a passage oft traversed by weary scholars and wandering minds alike. The grand archway beckons all who seek wisdom, but before one may delve into the depths of its scholarly halls, a test of perception must be met."
              " At the threshold, the scent of freshly baked bread and the aroma of roasted coffee linger in the air—a merchant’s haven set upon the very entrance to the keep. It is here, within the confines of this bustling outpost, that many weary travelers find solace before embarking upon their academic quests. The merchants of Panera, as they are known, offer sustenance and warmth, a momentary respite before the trials that await.\n\n"
              "     To proceed beyond this humble sanctuary, one must recall the **most common fare** sought by scholars and adventurers alike. The offering exchanged more than any other, **found upon the great menu board**, bears a number of great significance. Seek ye the first item, oft chosen, and only then shall the next path be revealed.\n\n"
              "**(Hint: The first item listed on the great menu of Panera is a clue.)**\n\n"
              "Enter the number of this offering and prove thy worth.",
      "code": "101"
    },
    {
      "image": "images/article2.png",
      "text": "**H**idden within these halls lies a space unlike any other, a sanctuary for those who seek both respite and camaraderie. **E**very scholar, knight, and traveler who walks these grounds finds themselves drawn to its warmth. **Y**ou will find here not only sustenance, but a place where knowledge and fellowship intertwine.\n\n"
              "**T**his atrium space is aptly named **“The Commons”**, serving as the **main gathering space** for all within the fortress of learning."
              " **I**t is a place of many faces, where students and adventurers pause between their quests, seeking nourishment for both body and mind."
              " **G**uardians of knowledge, the wise keepers of the **Dow Student Leadership Incubator**, watch over this hall, ensuring that the legacies of more than **40 student guilds** endure."
              " **E**very whisper and echo here tells of great minds meeting, ideas forming, and futures being shaped.\n\n"
              "**R**emember, traveler—the key lies not in the words themselves, but in their beginning.\n\n"
              "Only those who grasp this truth may proceed beyond this hall.",
      "code": "HEYTIGER"
    },
    {
      "image": "images/article3.png",
      "text": "     Through trials of knowledge and labor, only the most dedicated scholars reach the pinnacle of their craft. Beyond the bustling halls and the gathering spaces, there exists a sanctum of achievement—**The Capstone Gallery**."
              " Here, the works of aspiring engineers and visionaries are displayed, a testament to the countless hours of toil and innovation. Projects of metal, circuitry, and code stand as tributes to those who dare to shape the future."
              " Elevated above the common grounds, the **Capstone Steps** serve as both a pathway and a resting place, where minds weary from creation pause to reflect. The very stone beneath one’s feet carries the weight of past and present ingenuity."
              " Few, however, take note of the subtle details etched into this place of mastery. The unseen yet ever-present lifelines of energy and power await those who look closer. Each step, each resting point, holds within it a clue, a hidden pattern unnoticed by the untrained eye.\n\n"
              "Those who seek to progress must count not the achievements displayed, nor the scholars who gather, but rather the lifelines that fuel the very foundation of this place. Hidden in plain sight, the answer lies before you.\n\n"
              "Only those who truly observe will unveil the secret held within these steps.",
      "code": "15"
    },
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
      appBar: AppBar(title: Text('PFT Scavenger Hunt')),
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
                  setState(() {
                    if (currentLevel < articles.length - 1) {
                      currentLevel++;
                    }
                  });
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