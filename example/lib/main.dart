import 'package:detailed_gesture_detector/detailed_gesture_detector.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detailed GestureDetector Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GestureDetectorHome(),
    );
  }
}

class GestureDetectorHome extends StatelessWidget {
  const GestureDetectorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailedGestureDetector(
        onTap: (pointerDownEvent, pointerUpEvent) {
          print('onTap');
        },
        onScaleStart: (details, initialEvent, event) {
          print('onScaleStart');
        },
        onScaleUpdate: (details, initialEvent, event) {
          print('onScaleUpdate');
        },
        onScaleEnd: (details, initialEvent, event) {
          print('onScaleEnd');
        },
        child: Container(
          color: Colors.blue.shade900,
          child: const Center(
            child: Text(
              'Interact with me!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}