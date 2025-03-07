import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scavengerhutn/blank_page.dart'; // Import the new blank page

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlankPage()), // Now opens blank_page.dart
      );
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
              children: [
                Transform.scale(
                  scaleY: -1, 
                  child: Image.asset(
                    'images/divider.png',
                    width: 300,
                  ),
                ),

                SizedBox(height: 16),

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

                Image.asset(
                  'images/divider.png',
                  width: 300,
                ),

                SizedBox(height: 12),

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

                ElevatedButton(
                  onPressed: _checkCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Unlock'),
                ),

                SizedBox(height: 16),

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

  List<TextSpan> _formatArticleText(String text) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r'\*\*(.*?)\*\*');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    int lastIndex = 0;
    for (RegExpMatch match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      lastIndex = match.end;
    }
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }
}
