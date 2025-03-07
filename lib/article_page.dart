import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text('Location Article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Image.asset(widget.articleImage, width: double.infinity, height: 200, fit: BoxFit.cover),
            SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.left, 
              text: TextSpan(
                style: TextStyle(fontSize: 18, color: Colors.black, height: 1.5), 
                children: _formatArticleText(widget.articleText),
              ),
            ),
            Spacer(),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Enter Unlock Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
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

  List<TextSpan> _formatArticleText(String text) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r'\*\*(.*?)\*\*');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    int lastIndex = 0;
    for (RegExpMatch match in matches) {
      if (match.start > lastIndex) {
        String normalText = text.substring(lastIndex, match.start);
        normalText = normalText.replaceAll('\n', '\n\t');
        spans.add(TextSpan(text: '\t' + normalText)); 
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      lastIndex = match.end;
    }
    if (lastIndex < text.length) {
      String remainingText = text.substring(lastIndex);
      remainingText = remainingText.replaceAll('\n', '\n\t');
      spans.add(TextSpan(text: '\t' + remainingText));
    }

    return spans;
  }
}
