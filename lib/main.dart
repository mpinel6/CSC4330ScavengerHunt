import 'package:flutter/material.dart';
import 'package:scavengerhutn/article_page.dart';
import 'package:scavengerhutn/blank_page.dart';

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

  // Map image dimensions
  final double mapWidth = 2000; 
  final double mapHeight = 800;

  // Relative positions for buttons & markers
  final List<Offset> relativePositions = [
    Offset(0.08, 0.26),
    Offset(0.22, 0.24),
    Offset(0.7, 0.24),
  ];

  final List<Offset> relativeTigerPositions = [
    Offset(0.055, 0.3),
    Offset(0.20, 0.28),
    Offset(0.75, 0.28),
    Offset(0.8, 0.55),
  ];

  // Get dynamic positions
  Offset get buttonPosition => Offset(
        relativePositions[currentLevel].dx * mapWidth,
        relativePositions[currentLevel].dy * mapHeight,
      );

  Offset tigerPosition = Offset(0.055 * 2000, 0.3 * 800);
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> articles = [
    {
      "image": "images/article1.png",
      "text": "     Beyond the towering gates of **Patrick F. Taylor Hall**, a fortress of knowledge and innovation, lies a passage oft traversed by weary scholars and wandering minds alike. The grand archway beckons all who seek wisdom, but before one may delve into the depths of its scholarly halls, a test of perception must be met.\n\n"
              "     At the threshold, the scent of freshly baked bread and the aroma of roasted coffee linger in the air—a merchant’s haven set upon the very entrance to the keep. It is here, within the confines of this bustling outpost, that many weary travelers find solace before embarking upon their academic quests. The merchants of **Panera**, as they are known, offer sustenance and warmth, a momentary respite before the trials that await.\n\n"
              "     To proceed beyond this humble sanctuary, one must recall the **most common fare** sought by scholars and adventurers alike. The offering exchanged more than any other, **found upon the great menu board**, bears a number of great significance. Seek ye the first item, oft chosen, and only then shall the next path be revealed.\n\n"
              "**(Hint: The first item listed on the great menu of Panera is a clue.)**\n\n"
              "Enter the number of this offering and prove thy worth.",
      "code": "101"
    },
    {
      "image": "images/article2.png",
      "text": "**H**idden within these halls lies a space unlike any other, a sanctuary for those who seek both respite and camaraderie.\n\n"
              "**E**very scholar, knight, and traveler who walks these grounds finds themselves drawn to its warmth.\n\n"
              "**Y**ou will find here not only sustenance, but a place where knowledge and fellowship intertwine.\n\n"
              "**T**his atrium space is aptly named **“The Commons”**, serving as the **main gathering space** for all within the fortress of learning.\n\n"
              "**I**t is a place of many faces, where students and adventurers pause between their quests, seeking nourishment for both body and mind.\n\n"
              "**G**uardians of knowledge, the wise keepers of the **Dow Student Leadership Incubator**, watch over this hall, ensuring that the legacies of more than **40 student guilds** endure.\n\n"
              "**E**very whisper and echo here tells of great minds meeting, ideas forming, and futures being shaped.\n\n"
              "**R**emember, traveler—the key lies not in the words themselves, but in their beginning.\n\n"
              "Only those who grasp this truth may proceed beyond this hall.",
      "code": "HEYTIGER"
    },
    {
      "image": "images/article3.png",
      "text": "Through trials of knowledge and labor, only the most dedicated scholars reach the pinnacle of their craft. Beyond the bustling halls and the gathering spaces, there exists a sanctum of achievement—**The Capstone Gallery**."
              " Here, the works of aspiring engineers and visionaries are displayed, a testament to the countless hours of toil and innovation. Projects of metal, circuitry, and code stand as tributes to those who dare to shape the future."
              " Elevated above the common grounds, the **Capstone Steps** serve as both a pathway and a resting place, where minds weary from creation pause to reflect. The very stone beneath one’s feet carries the weight of past and present ingenuity."
              " Few, however, take note of the subtle details etched into this place of mastery. The unseen yet ever-present lifelines of energy and power await those who look closer. Each step, each resting point, holds within it a clue, a hidden pattern unnoticed by the untrained eye.\n\n"
              "Those who seek to progress must count not the achievements displayed, nor the scholars who gather, but rather the lifelines that fuel the very foundation of this place. Hidden in plain sight, the answer lies before you.\n\n"
              "Only those who truly observe will unveil the secret held within these steps.",
      "code": "15"
    },
  ];

void unlockNextLevel() async {
  if (currentLevel < relativePositions.length - 1) {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlankPage(gameType: currentLevel + 1)), // Assigns game placeholder
    );

    setState(() {
      currentLevel++;
      tigerPosition = Offset(
        relativeTigerPositions[currentLevel].dx * mapWidth,
        relativeTigerPositions[currentLevel].dy * mapHeight,
      );
    });
  } else {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlankPage(gameType: 3)), // Placeholder for final game
    );

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
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PFT Scavenger Hunt')),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            width: mapWidth,
            height: mapHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'images/map_image.png',
                    fit: BoxFit.cover,
                  ),
                ),

                AnimatedPositioned(
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  left: tigerPosition.dx,
                  top: tigerPosition.dy,
                  child: Image.asset(
                    'images/Tiger_marker.png',
                    width: 80,
                    height: 80,
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
          ),
        ),
      ),
    );
  }
}
