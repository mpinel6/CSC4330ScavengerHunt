import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BlankPage extends StatefulWidget {
  final int gameType;
  BlankPage({required this.gameType});

  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> with TickerProviderStateMixin {
  //words to pick from
  final List<String> wordPool = [
    'TIGER', 'ROAR', 'LSU', 'JUNGLE', 'CLAW',
    'PAWS', 'SWIFT', 'FOCUS', 'STRIKE', 'STRIPES',
    'PROWL', 'SPIRIT', 'CHAMPION', 'STUDY',
  ];

  late List<String> words; //selected words
  int obstacleIndex = 0; //current obstacle
  late String currentWord; //word to type
  String typedSoFar = ''; //typing progress

  // Jump animations
  late AnimationController _jumpController;
  late Animation<double> _jumpAnimation;
  bool isJumping = false;

  // Enemy animations
  late AnimationController _obstacleController;
  late Animation<double> _obstacleX;

  bool gameFinished = false;

  final FocusNode _focusNode = FocusNode(); //keyboard focus

  @override
  void initState() {
    super.initState();
    _setupGame(); //initial setup
  }

  void _setupGame() {
    //shuffle and pick words
    final random = math.Random();
    final shuffledPool = List<String>.from(wordPool)..shuffle(random);
    words = shuffledPool.take(3).toList();

    obstacleIndex = 0;
    currentWord = words[obstacleIndex];

    //jump controller
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _jumpAnimation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(parent: _jumpController, curve: Curves.easeInOut),
    );

    _jumpController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _jumpController.reverse().whenComplete(() {
          setState(() {
            isJumping = false;
            obstacleIndex++;
            if (obstacleIndex < words.length) {
              currentWord = words[obstacleIndex];
              typedSoFar = '';
              _obstacleController.forward(from: 0);
            } else {
              gameFinished = true;
            }
          });
        });
      }
    });

    //enemy controller
    _obstacleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _obstacleX = Tween<double>(begin: 0, end: 240).animate(
      CurvedAnimation(parent: _obstacleController, curve: Curves.linear),
    );

    _obstacleX.addStatusListener((status) {
      if (status == AnimationStatus.completed && !isJumping && !gameFinished) {
        restartGame();
      }
    });

    _obstacleController.forward();
  }

  @override
  void dispose() {
    //cleanup
    _jumpController.dispose();
    _obstacleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void checkTyping() {
    //match typed with current
    if (typedSoFar.toUpperCase() == currentWord.toUpperCase()) {
      triggerJump();
    }
  }

  void triggerJump() {
    //tiger jumps
    setState(() {
      isJumping = true;
    });
    _jumpController.forward(from: 0);
  }

  void restartGame() {
    //reset everything in game
    setState(() {
      final random = math.Random();
      final shuffledPool = List<String>.from(wordPool)..shuffle(random);
      words = shuffledPool.take(3).toList();

      obstacleIndex = 0;
      currentWord = words[obstacleIndex];
      typedSoFar = '';
      gameFinished = false;
      isJumping = false;

      _jumpController.reset();
      _obstacleController.reset();
      _obstacleController.forward();
    });
  }

  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
    //capture keystrokes
    if (gameFinished) return KeyEventResult.ignored;

    if (event is KeyDownEvent) {
      final String? character = event.character;
      if (character != null && character.isNotEmpty) {
        if (character.length == 1) {
          setState(() {
            typedSoFar += character.toUpperCase();
          });
          if (!currentWord.toUpperCase().startsWith(typedSoFar)) {
            typedSoFar = '';
          }
          checkTyping();
        }
      }

      if (event.physicalKey == PhysicalKeyboardKey.backspace && typedSoFar.isNotEmpty) {
        setState(() {
          typedSoFar = typedSoFar.substring(0, typedSoFar.length - 1);
        });
      }
    }

    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        autofocus: true,
        focusNode: _focusNode,
        onKeyEvent: handleKeyEvent,
        child: Stack(
          children: [
            //background
            Positioned.fill(
              child: Image.asset(
                'images/background_image.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //divider (flipped)
                  Transform.scale(
                    scaleY: -1,
                    child: Image.asset(
                      'images/divider.png',
                      width: 300,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Game Title + End Screen
                  if (!gameFinished) ...[
                    Text(
                      'Typing Tiger Game',
                      style: GoogleFonts.medievalSharp(
                        fontSize: 24,
                        color: const Color.fromARGB(255, 31, 20, 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Type the word before the enemies reach you!',
                      style: GoogleFonts.medievalSharp(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 31, 20, 18),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'You did it! All enemies destroyed!',
                      style: GoogleFonts.medievalSharp(
                        fontSize: 24,
                        color: const Color.fromARGB(255, 31, 20, 18),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12
                        ),
                        textStyle: GoogleFonts.medievalSharp(fontSize: 20),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                  const SizedBox(height: 16),

                  //tiger, typed text, and enemy
                  if (!gameFinished)
                    SizedBox(
                      width: 300,
                      height: 150,
                      child: AnimatedBuilder(
                        animation: Listenable.merge([
                          _jumpAnimation,
                          _obstacleX,
                        ]),
                        builder: (context, child) {
                          //Calculate obstacle position
                          double obstacleLeft = 300 - 20 - _obstacleX.value;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                bottom: 0 + _jumpAnimation.value,
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Image.asset(
                                    'images/Tiger_marker.png',
                                    width: 90,
                                    height: 90,
                                  ),
                                ),
                              ),
                              //typed user text
                              Positioned(
                                left: 60,
                                bottom: 120,
                                child: Container(
                                  width: 200,
                                  alignment: Alignment.center,
                                  child: Text(
                                    typedSoFar,
                                    style: GoogleFonts.medievalSharp(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              //Enemy
                              Positioned(
                                left: obstacleLeft,
                                bottom: 0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentWord,
                                      style: GoogleFonts.medievalSharp(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Image.asset(
                                      'images/slime.gif',
                                      width: 80,
                                      height: 80,
                                      gaplessPlayback: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  //Bottom divider
                  Image.asset(
                    'images/divider.png',
                    width: 300,
                  ),
                  const SizedBox(height: 20),
                  //back to map
                  if (!gameFinished)
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12
                        ),
                        textStyle: GoogleFonts.medievalSharp(fontSize: 20),
                      ),
                      child: const Text('Back to Map'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
