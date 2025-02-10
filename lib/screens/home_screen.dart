import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'recording_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _startRecording(BuildContext context) async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => RecordingScreen()));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/mic.json',
              height: 200,
              width: 500
          ),
          Text("Speaker Timer App", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
          ElevatedButton.icon(
            onPressed: () => _startRecording(context),
            icon: Icon(Icons.mic, color: Colors.white),
            label: Text("Start recording", style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              // Navigate to History Screen (To be implemented later)
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("View History", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
