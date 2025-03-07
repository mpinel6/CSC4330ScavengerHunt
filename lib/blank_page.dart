import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/background_image.png', 
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scaleY: -1, 
                  child: Image.asset(
                    'images/divider.png',
                    width: 300,
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  "A New Path Awaits...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.medievalSharp(
                    fontSize: 28,
                    color: const Color.fromARGB(255, 31, 20, 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 16),

                Image.asset(
                  'images/divider.png',
                  width: 300,
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: GoogleFonts.medievalSharp(fontSize: 20),
                  ),
                  child: Text("Continue"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}