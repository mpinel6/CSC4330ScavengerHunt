import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlePage extends StatefulWidget {
  final String articleImage;
  final String articleText;
  final String correctCode;

  ArticlePage({
    Key? key,
    required this.articleImage,
    required this.articleText,
    required this.correctCode,
  }) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final TextEditingController _codeController = TextEditingController();
  String message = "";

  void _checkCode() {
    if (_codeController.text == widget.correctCode) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        message = "Incorrect code. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (Parchment-Style)
          Positioned.fill(
            child: Image.asset(
              'images/background_image.png', // Add a parchment-like texture
              fit: BoxFit.cover,
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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

                // Article Image (Large Display)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.articleImage,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 16),

                // Handwritten Style Article Text with Bold Formatting
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: GoogleFonts.medievalSharp(
                            fontSize: 25,
                            color: const Color.fromARGB(255, 31, 20, 18),
                            height: 1.6,
                          ),
                          children: _formatArticleText(widget.articleText),
                        ),
                      ),
                    ),
                  ),
                ),

                // Decorative Footer Image
                Image.asset(
                  'images/divider.png', // Another decorative divider
                  width: 300,
                ),

                SizedBox(height: 12),

                // Code Entry Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.brown, width: 2),
                  ),
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _codeController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Enter Unlock Code',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),

                SizedBox(height: 16),

                // Unlock Button
                ElevatedButton(
                  onPressed: _checkCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700], // Old paper feel
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Unlock'),
                ),

                SizedBox(height: 16),

                // Incorrect Code Message
                Text(
                  message,
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// **Helper function to format bold text inside the article text**
  List<TextSpan> _formatArticleText(String text) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r'\*\*(.*?)\*\*'); // Matches **bold text**
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    int lastIndex = 0;
    for (RegExpMatch match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start))); // Normal text
      }
      spans.add(TextSpan(
        text: match.group(1), // Bold text
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      lastIndex = match.end;
    }
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex))); // Remaining normal text
    }

    return spans;
  }
}