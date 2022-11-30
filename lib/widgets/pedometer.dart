import 'package:flutter/material.dart';
import 'package:twalk_app/constants/common.dart';

class Pedometer extends StatelessWidget {
  const Pedometer(this.step, {Key? key}) : super(key: key);
  final int step;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$step',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                  )),
              const SizedBox(
                width: 5.0,
              ),
              const Text('걸음',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: primaryColor)),
            ],
          ),
        ));
  }
}
