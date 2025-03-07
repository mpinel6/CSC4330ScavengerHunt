import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  final String articleImage;
  final String articleText;
  final String correctCode;

  ArticlePage({required this.articleImage, required this.articleText, required this.correctCode});

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
      appBar: AppBar(title: Text('Unlock the Next Level')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(widget.articleImage, width: double.infinity, height: 200, fit: BoxFit.cover),
            SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: [
                  TextSpan(text: "Beyond the towering gates of "),
                  TextSpan(
                    text: "Patrick F. Taylor Hall",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ", a fortress of knowledge and innovation, lies a passage oft traversed by weary scholars and wandering minds alike. The grand archway beckons all who seek wisdom, but before one may delve into the depths of its scholarly halls, a test of perception must be met.\n\n"),
                  
                  TextSpan(text: "At the threshold, the scent of freshly baked bread and the aroma of roasted coffee linger in the air—a merchant’s haven set upon the very entrance to the keep. It is here, within the confines of this bustling outpost, that many weary travelers find solace before embarking upon their academic quests. The merchants of "),
                  TextSpan(
                    text: "Panera",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ", as they are known, offer sustenance and warmth, a momentary respite before the trials that await.\n\n"),
                  
                  TextSpan(text: "To proceed beyond this humble sanctuary, one must recall the "),
                  TextSpan(
                    text: "most common fare",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " sought by scholars and adventurers alike. The offering exchanged more than any other, "),
                  TextSpan(
                    text: "found upon the great menu board",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ", bears a number of great significance. Seek ye the first item, oft chosen, and only then shall the next path be revealed.\n\n"),

                  TextSpan(
                    text: "(Hint: The first item listed on the great menu of Panera is a clue.)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                  TextSpan(text: "\n\nEnter the number of this offering and prove thy worth."),
                ],
              ),
            ),
            Spacer(),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Enter Unlock Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkCode,
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
    );
  }
}
