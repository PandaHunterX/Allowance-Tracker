import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String words;
  final double size;
  final FontWeight fontWeight;

  const TitleText({required this.words, required this.size, super.key, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      words,
      minFontSize: 12,
      style: TextStyle(
          fontWeight: fontWeight,
          fontSize: size,
          fontFamily: 'Signika Negative'),
    );
  }
}

class SecondaryText extends StatelessWidget {
  final String words;
  final double size;
  final int maxLines;
  const SecondaryText({super.key, required this.words, required this.size, required this.maxLines});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      words,
      minFontSize: 8,
      maxLines: maxLines,
      style: TextStyle(
          fontSize: size,
          fontFamily: 'PTSans'),
    );
  }
}
