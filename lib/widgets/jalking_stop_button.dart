import 'package:flutter/material.dart';
import 'package:twalk_app/constants/common.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';

class JalkingStopButton extends StatelessWidget {
  const JalkingStopButton({Key? key, required this.content}) : super(key: key);
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(radiusCircular),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Text(content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            )),
      ),
    );
  }
}
