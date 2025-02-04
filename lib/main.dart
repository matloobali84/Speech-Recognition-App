import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SpeakerTimerApp());
}

class SpeakerTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speaker Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
