import 'package:flutter/material.dart';

class PvpScore extends StatelessWidget {
  const PvpScore({
    Key? key,
    this.wins = 0,
    this.loses = 0,
    this.width,
    this.padding,
    this.fontSize,
    this.backgroundColor,
    this.fontWeight,
  }) : super(key: key);

  final wins;
  final loses;
  final width;
  final padding;
  final fontSize;
  final backgroundColor;
  final fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        padding: padding,
        color: backgroundColor,
        child: Text(
          '전적 $wins승 $loses패',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ));
  }
}
