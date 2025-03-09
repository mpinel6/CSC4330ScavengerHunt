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
  late List<String> words;
  int obstacleIndex = 0;
  late String currentWord;
  String typedSoFar = '';

  late AnimationController _jumpController;
  late Animation<double> _jumpAnimation;
  bool isJumping = false;

  late AnimationController _obstacleController;
  late Animation<double> _obstacleX;

  bool gameFinished = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    words = ['TIGER', 'ROAR', 'LSU'];

    currentWord = words[obstacleIndex];

    _jumpController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
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

    _obstacleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );


    _obstacleX = Tween<double>(begin: 0, end: 240).animate(
      CurvedAnimation(parent: _obstacleController, curve: Curves.linear),
    );

    _obstacleX.addStatusListener((status) {
      if (status == AnimationStatus.completed && !isJumping && !gameFinished) {
        //need to implement restarting the game
      }
    });

    _obstacleController.forward();
  }

  @override
  void dispose() {
    _jumpController.dispose();
    _obstacleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void checkTyping() {
    if (typedSoFar.toUpperCase() == currentWord.toUpperCase()) {
      //need to implement tiger animation :)
    }
  }

  KeyEventResult handleKeyEvent(FocusNode node, KeyEvent event) {
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
                  Transform.scale(
                    scaleY: -1,
                    child: Image.asset(
                      'images/divider.png',
                      width: 300,
                    ),
                  ),
                  SizedBox(height: 16),


                  if (!gameFinished) ...[
                    Text(
                      'Typing Tiger Game',
                      style: GoogleFonts.medievalSharp(
                        fontSize: 24,
                        color: Color.fromARGB(255, 31, 20, 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Type the word before the enemies reach you!',
                      style: GoogleFonts.medievalSharp(
                        fontSize: 18,
                        color: Color.fromARGB(255, 31, 20, 18),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'You did it! All enemies destroyed!',
                      style: GoogleFonts.medievalSharp(
                        fontSize: 24,
                        color: Color.fromARGB(255, 31, 20, 18),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: GoogleFonts.medievalSharp(fontSize: 20),
                      ),
                      child: Text('Continue'),
                    ),
                  ],
                  SizedBox(height: 16),


                  if (!gameFinished)
                    SizedBox(
                      width: 300,
                      height: 150,
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_jumpAnimation, _obstacleX]),
                        builder: (context, child) {
                          double obstacleLeft = 300 - 60 - _obstacleX.value;


                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                bottom: 0 + _jumpAnimation.value,
                                child: Image.asset(
                                  'images/Tiger_marker.png',
                                  width: 60,
                                  height: 60,
                                ),
                              ),


                              Positioned(
                                left: 120,
                                bottom: 40,
                                child: Container(
                                  width: 60,
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
                                    SizedBox(height: 4),
                                    Image.asset(
                                      'images/button_image.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                  SizedBox(height: 24),

                  Image.asset(
                    'images/divider.png',
                    width: 300,
                  ),
                  SizedBox(height: 20),


                  if (!gameFinished)
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: GoogleFonts.medievalSharp(fontSize: 20),
                      ),
                      child: Text('Back to Map'),
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



