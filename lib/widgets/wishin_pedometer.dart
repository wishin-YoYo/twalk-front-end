import 'package:flutter/material.dart';
import 'package:twalk_app/constants/common.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishinPedometer extends StatefulWidget {
  const WishinPedometer({Key? key}) : super(key: key);

  @override
  State<WishinPedometer> createState() => _WishinPedometerState();
}

class _WishinPedometerState extends State<WishinPedometer> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  static const _updateInterval = 10;
  static bool inited = false;
  static int steps = 0;

  @override
  void initState() {
    super.initState();
    _getFromStorage();
    initPlatformState();
  }

  Future<void> _getFromStorage() async {
    final storage = await SharedPreferences.getInstance();
    setState(() {
      steps = storage.getInt('steps') ?? 0;
    });
    inited = true;
  }

  Future<void> _saveToStorage() async {
    final storage = await SharedPreferences.getInstance();
    if (inited) {
      await storage.setInt('steps', steps);
    }
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
      steps++;
    });
    if (steps % _updateInterval == 0) {
      _saveToStorage();
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    print('[CGCG] onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          width: 300.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$steps',
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

  @override
  void dispose() {
    _saveToStorage();
    super.dispose();
  }
}
