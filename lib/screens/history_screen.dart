// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:lottie/lottie.dart';
//
// class RecordingScreen extends StatefulWidget {
//   @override
//   _RecordingScreenState createState() => _RecordingScreenState();
// }
//
// class _RecordingScreenState extends State<RecordingScreen> {
//   // WebRTC Variables
//   MediaStream? _localStream;
//
//   // Real-Time Graph Data
//   List<double> _speechLevels = [];  // Holds speech data for graph
//   bool _isSpeaking = false;
//   int _silenceStart = 0;  // Track the silence start time
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeWebRTC();
//   }
//
//   // Initialize WebRTC for capturing audio
//   Future<void> _initializeWebRTC() async {
//     final mediaConstraints = {'audio': true, 'video': false};
//     try {
//       final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       setState(() {
//         _localStream = stream;
//       });
//       _startAudioProcessing(stream);
//     } catch (e) {
//       print("Error getting media: $e");
//     }
//   }
//
//   // Process Audio to Detect Speech and Silence
//   void _startAudioProcessing(MediaStream stream) {
//     final audioTrack = stream.getAudioTracks()[0];
//
//     // Processing the audio to get speech levels and silence
//     Timer.periodic(Duration(milliseconds: 500), (timer) async {
//       final audioLevel = await _getAudioLevel(audioTrack);  // Get audio level
//
//       // If audio level crosses a threshold, consider it speech
//       if (audioLevel > 0.1) {  // Threshold for speech
//         if (!_isSpeaking) {
//           setState(() {
//             _isSpeaking = true;
//           });
//         }
//         _speechLevels.add(audioLevel);  // Add speech level data for graph
//         _silenceStart = 0;  // Reset silence time when speech is detected
//       } else {
//         if (_isSpeaking) {
//           setState(() {
//             _isSpeaking = false;
//           });
//         }
//         _silenceStart++;  // Track silence time
//         _speechLevels.add(0.0);  // Add silence level data for graph
//
//         // Limit the graph data size to 30
//         if (_speechLevels.length > 30) {
//           _speechLevels.removeAt(0); // Remove oldest data point
//         }
//       }
//
//       // Limit graph data size to 30
//       if (_speechLevels.length > 30) {
//         _speechLevels.removeAt(0); // Remove oldest data point
//       }
//     });
//   }
//
//   // This is a placeholder function. Replace with actual logic to get audio levels.
//   Future<double> _getAudioLevel(MediaStreamTrack track) async {
//     // In a real implementation, we should analyze the audio stream to get the level.
//     // For now, we are simulating speech levels.
//     return 0.05; // Simulated audio level (low)
//   }
//
//   // Stop recording and clear resources
//   void _stopRecording() {
//     _localStream?.getTracks().forEach((track) {
//       track.stop();
//     });
//     Navigator.pop(context); // Go back to Home Screen
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _stopRecording();  // Stop recording when the screen is disposed
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text("Recording Session"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Recording Animation
//           Lottie.asset(
//             'assets/animations/recording.json',
//             height: 120,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "🎙️ Recording...",
//             style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//
//           // Timer Display for Speakers & Silence Time
//           Container(
//             padding: EdgeInsets.all(20),
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("🕒 A: 05:23", style: TextStyle(fontSize: 18, color: Colors.white)),
//                     Text("🕒 B: 03:45", style: TextStyle(fontSize: 18, color: Colors.white)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("🔕 Silence: 01:10", style: TextStyle(fontSize: 18, color: Colors.orange)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 30),
//
//           // Real-Time Graph for Speech Levels
//           Container(
//             width: double.infinity,
//             height: 200,
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey[850],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: LineChart(
//                 LineChartData(
//                   borderData: FlBorderData(show: true),
//                   gridData: FlGridData(show: true),
//                   titlesData: FlTitlesData(show: true),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: _speechLevels
//                           .asMap()
//                           .map((index, value) => MapEntry(
//                           index,
//                           FlSpot(index.toDouble(), value)))
//                           .values
//                           .toList(),
//                       isCurved: true,
//                       // colors: [Colors.redAccent],  // Use 'colors' instead of 'barColors'
//                       belowBarData: BarAreaData(show: false),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 30),
//
//           // Stop Recording Button
//           ElevatedButton(
//             onPressed: _stopRecording,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             child: Text("🛑 Stop Recording", style: TextStyle(fontSize: 20, color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
// Code Update 2
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:lottie/lottie.dart';
//
// class RecordingScreen extends StatefulWidget {
//   @override
//   _RecordingScreenState createState() => _RecordingScreenState();
// }
//
// class _RecordingScreenState extends State<RecordingScreen> {
//   // WebRTC Variables
//   MediaStream? _localStream;
//
//   // Real-Time Graph Data
//   List<double> _speechLevels = []; // Holds speech data for graph
//   bool _isSpeaking = false;
//   int _silenceStart = 0; // Track the silence start time
//
//   // Timers for each speaker
//   int _speakerATime = 0; // Time spent by Speaker A
//   int _speakerBTime = 0; // Time spent by Speaker B
//   int _speakerAMutedTime = 0; // Time of silence for Speaker A
//   int _speakerBMutedTime = 0; // Time of silence for Speaker B
//   bool _isSpeakerA = true; // Toggle between speakers
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeWebRTC();
//   }
//
//   // Initialize WebRTC for capturing audio
//   Future<void> _initializeWebRTC() async {
//     final mediaConstraints = {'audio': true, 'video': false};
//     try {
//       final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//       setState(() {
//         _localStream = stream;
//       });
//       _startAudioProcessing(stream);
//     } catch (e) {
//       print("Error getting media: $e");
//     }
//   }
//
//   // Process Audio to Detect Speech and Silence
//   void _startAudioProcessing(MediaStream stream) {
//     final audioTrack = stream.getAudioTracks()[0];
//
//     // Processing the audio to get speech levels and silence
//     Timer.periodic(Duration(milliseconds: 500), (timer) async {
//       final audioLevel = await _getAudioLevel(audioTrack);  // Get audio level
//
//       // If audio level crosses a threshold, consider it speech
//       if (audioLevel > 0.1) {  // Threshold for speech
//         if (!_isSpeaking) {
//           setState(() {
//             _isSpeaking = true;
//           });
//         }
//
//         // Update time based on the current speaker
//         setState(() {
//           if (_isSpeakerA) {
//             _speakerATime++;
//           } else {
//             _speakerBTime++;
//           }
//         });
//
//         _speechLevels.add(audioLevel);  // Add speech level data for graph
//         _silenceStart = 0;  // Reset silence time when speech is detected
//       } else {
//         if (_isSpeaking) {
//           setState(() {
//             _isSpeaking = false;
//           });
//         }
//
//         // Track silence time
//         if (_isSpeakerA) {
//           _speakerAMutedTime++;
//         } else {
//           _speakerBMutedTime++;
//         }
//
//         _speechLevels.add(0.0);  // Add silence level data for graph
//         _silenceStart++;
//       }
//
//       // Limit the graph data size to 30
//       if (_speechLevels.length > 30) {
//         _speechLevels.removeAt(0); // Remove oldest data point
//       }
//     });
//   }
//
//   // Get audio level (simulate for now)
//   Future<double> _getAudioLevel(MediaStreamTrack track) async {
//     // In a real implementation, we should analyze the audio stream to get the level.
//     // For now, we are simulating speech levels.
//     return 0.05; // Simulated audio level (low)
//   }
//
//   // Switch between speakers based on silence duration
//   void _switchSpeaker() {
//     if (_silenceStart > 10) {  // Consider switching after 10 seconds of silence
//       setState(() {
//         _isSpeakerA = !_isSpeakerA; // Switch speakers
//       });
//     }
//   }
//
//   // Stop recording and clear resources
//   void _stopRecording() {
//     _localStream?.getTracks().forEach((track) {
//       track.stop();
//     });
//     Navigator.pop(context); // Go back to Home Screen
//   }
//
//   // Format time in minutes and seconds
//   String _formatTime(int seconds) {
//     int minutes = (seconds ~/ 60);
//     int sec = seconds % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _stopRecording();  // Stop recording when the screen is disposed
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text("Recording Session"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Recording Animation
//           Lottie.asset(
//             'assets/animations/recording.json',
//             height: 120,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "🎙️ Recording...",
//             style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//
//           // Timer Display for Speakers & Silence Time
//           Container(
//             padding: EdgeInsets.all(20),
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("🕒 A: ${_formatTime(_speakerATime)}", style: TextStyle(fontSize: 18, color: Colors.white)),
//                     Text("🕒 B: ${_formatTime(_speakerBTime)}", style: TextStyle(fontSize: 18, color: Colors.white)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("🔕 Silence A: ${_formatTime(_speakerAMutedTime)}", style: TextStyle(fontSize: 14, color: Colors.orange)),
//                     Text("🔕 Silence B: ${_formatTime(_speakerBMutedTime)}", style: TextStyle(fontSize: 14, color: Colors.orange)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 30),
//
//           // Real-Time Graph for Speech Levels
//           Container(
//             width: double.infinity,
//             height: 200,
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey[850],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: LineChart(
//                 LineChartData(
//                   borderData: FlBorderData(show: true),
//                   gridData: FlGridData(show: true),
//                   titlesData: FlTitlesData(show: true),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: _speechLevels
//                           .asMap()
//                           .entries
//                           .map((e) => FlSpot(e.key.toDouble(), e.value))
//                           .toList(),
//                       isCurved: true,
//                       // colors: [Colors.green],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//
//           // Stop Button
//           ElevatedButton.icon(
//             onPressed: _stopRecording,
//             icon: Icon(Icons.stop, color: Colors.white), // 🛑 Stop icon
//             label: Text("Stop Recording", style: TextStyle(fontSize: 18, color: Colors.white)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// updated code that dislpay random graph
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  // WebRTC Variables
  MediaStream? _localStream;

  // Real-Time Graph Data
  List<double> _speechLevels = [];
  bool _isSpeaking = false;

  // Timers for each speaker
  int _speakerATime = 0;
  int _speakerBTime = 0;
  int _speakerAMutedTime = 0;
  int _speakerBMutedTime = 0;
  bool _isSpeakerA = true; // Default: Speaker A

  @override
  void initState() {
    super.initState();
    _initializeWebRTC();
  }

  // Initialize WebRTC for capturing audio
  Future<void> _initializeWebRTC() async {
    final mediaConstraints = {'audio': true, 'video': false};
    try {
      final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      setState(() {
        _localStream = stream;
      });
      _startAudioProcessing(stream);
    } catch (e) {
      print("Error getting media: $e");
    }
  }

  // Process Audio to Detect Speech and Silence
  void _startAudioProcessing(MediaStream stream) {
    final audioTrack = stream.getAudioTracks()[0];

    Timer.periodic(Duration(milliseconds: 500), (timer) async {
      final audioLevel = await _getAudioLevel(audioTrack);

      setState(() {
        if (audioLevel > 0.1) {
          _isSpeaking = true;
          if (_isSpeakerA) {
            _speakerATime++;
          } else {
            _speakerBTime++;
          }
        } else {
          _isSpeaking = false;
          if (_isSpeakerA) {
            _speakerAMutedTime++;
          } else {
            _speakerBMutedTime++;
          }
        }

        _speechLevels.add(audioLevel);
        if (_speechLevels.length > 30) _speechLevels.removeAt(0);
      });
    });
  }

  // Simulated audio level
  Future<double> _getAudioLevel(MediaStreamTrack track) async {
    return (_speechLevels.length % 10) * 0.05;
  }

  // Manually switch speakers when button is clicked
  void _switchSpeaker() {
    setState(() {
      _isSpeakerA = !_isSpeakerA;
    });
  }

  // Stop recording
  void _stopRecording() {
    _localStream?.getTracks().forEach((track) => track.stop());
    Navigator.pop(context);
  }

  // Format time display
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _stopRecording();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Recording Session"), backgroundColor: Colors.redAccent),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/recording.json', height: 120),
          SizedBox(height: 10),
          Text("🎙️ Recording...", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),

          // Timer Display
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("🕒 A: ${_formatTime(_speakerATime)}", style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text("🕒 B: ${_formatTime(_speakerBTime)}", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("🔕 Silence A: ${_formatTime(_speakerAMutedTime)}", style: TextStyle(fontSize: 14, color: Colors.orange)),
                    Text(" 🔕 Silence B: ${_formatTime(_speakerBMutedTime)}", style: TextStyle(fontSize: 14, color: Colors.orange)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),

          // Real-Time Graph
          Container(
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _speechLevels.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          // Manual Speaker Switch Button
          ElevatedButton.icon(
            onPressed: _switchSpeaker,
            icon: Icon(Icons.swap_horiz, color: Colors.white),
            label: Text("Switch to Other Speaker", style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),

          // Stop Button
          ElevatedButton.icon(
            onPressed: _stopRecording,
            icon: Icon(Icons.stop, color: Colors.white),
            label: Text("Stop Recording", style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}


// this the the code that dispaly the actully graph with my microphone



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:lottie/lottie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';
//
// class RecordingScreen extends StatefulWidget {
//   @override
//   _RecordingScreenState createState() => _RecordingScreenState();
// }
//
// class _RecordingScreenState extends State<RecordingScreen> {
//   // FlutterSound Recorder
//   FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
//   bool _isRecording = false;
//   String _filePath = '';
//
//   // Timers for each speaker
//   int _speakerATime = 0;
//   int _speakerBTime = 0;
//   int _speakerAMutedTime = 0;
//   int _speakerBMutedTime = 0;
//   bool _isSpeakerA = true;
//
//   // Audio waveform controller
//   late RecorderController _waveformController;
//   List<double> _speechLevels = [];
//
//   StreamSubscription? _recorderSubscription;
//   Stopwatch _speakerAStopwatch = Stopwatch();
//   Stopwatch _speakerBStopwatch = Stopwatch();
//   Stopwatch _silenceStopwatch = Stopwatch();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeRecorder();
//     _waveformController = RecorderController();
//   }
//
//   // Initialize recorder
//   Future<void> _initializeRecorder() async {
//     final dir = await getApplicationDocumentsDirectory();
//     _filePath = '${dir.path}/recorded_audio.aac';
//     await _audioRecorder.openRecorder();
//     await _audioRecorder.setSubscriptionDuration(Duration(milliseconds: 100));
//
//     // Listen to recorder progress
//     _recorderSubscription = _audioRecorder.onProgress!.listen((event) {
//       final level = event.decibels ?? 0.0;
//       _updateSpeechLevels(level);
//     });
//
//     _waveformController.record(); // Start waveform recording
//   }
//
//   // Update Speech Levels
//   void _updateSpeechLevels(double audioLevel) {
//     setState(() {
//       if (audioLevel > 0.05) {
//         _silenceStopwatch.stop();
//
//         if (_isSpeakerA) {
//           _speakerAStopwatch.start();
//           _speakerBStopwatch.stop();
//           _speakerATime = _speakerAStopwatch.elapsed.inSeconds;
//         } else {
//           _speakerBStopwatch.start();
//           _speakerAStopwatch.stop();
//           _speakerBTime = _speakerBStopwatch.elapsed.inSeconds;
//         }
//       } else {
//         _silenceStopwatch.start();
//         if (_isSpeakerA) {
//           _speakerAMutedTime = _silenceStopwatch.elapsed.inSeconds;
//         } else {
//           _speakerBMutedTime = _silenceStopwatch.elapsed.inSeconds;
//         }
//       }
//
//       // Store real-time levels for visualization
//       _speechLevels.add(audioLevel);
//       if (_speechLevels.length > 30) {
//         _speechLevels.removeAt(0);
//       }
//     });
//   }
//
//   // Start Recording
//   void _startRecording() async {
//     if (!_isRecording) {
//       await _audioRecorder.startRecorder(toFile: _filePath);
//       _waveformController.record(); // Start waveform
//       setState(() {
//         _isRecording = true;
//       });
//     }
//   }
//
//   // Stop Recording
//   void _stopRecording() async {
//     if (_isRecording) {
//       await _audioRecorder.stopRecorder();
//       _waveformController.stop(); // Stop waveform
//       setState(() {
//         _isRecording = false;
//       });
//       print("Recording saved to: $_filePath");
//     }
//   }
//
//   // Switch Speaker
//   void _switchSpeaker() {
//     setState(() {
//       _isSpeakerA = !_isSpeakerA;
//     });
//   }
//
//   // Format time
//   String _formatTime(int seconds) {
//     int minutes = seconds ~/ 60;
//     int sec = seconds % 60;
//     return "${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   void dispose() {
//     _audioRecorder.closeRecorder();
//     _recorderSubscription?.cancel();
//     _waveformController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text("Recording Session"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset('assets/animations/recording.json', height: 120),
//           const SizedBox(height: 10),
//           Text("🎙️ Recording...",
//               style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//
//           // Timer Display
//           Container(
//             padding: EdgeInsets.all(20),
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("🕒 A: ${_formatTime(_speakerATime)}",
//                         style: TextStyle(fontSize: 18, color: Colors.white)),
//                     Text("🕒 B: ${_formatTime(_speakerBTime)}",
//                         style: TextStyle(fontSize: 18, color: Colors.white)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("🔕 Silence A: ${_formatTime(_speakerAMutedTime)}",
//                         style: TextStyle(fontSize: 14, color: Colors.orange)),
//                     Text("🔕 Silence B: ${_formatTime(_speakerBMutedTime)}",
//                         style: TextStyle(fontSize: 14, color: Colors.orange)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 30),
//
//           // Audio Waveform
//           Container(
//             width: double.infinity,
//             height: 200,
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey[850],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: AudioWaveforms(
//                 recorderController: _waveformController, // Required parameter
//                 size: Size(double.infinity, 200),
//                 waveStyle: WaveStyle(
//                   waveColor: Colors.green,
//                   showMiddleLine: true,
//                   middleLineColor: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//
//           // Start / Stop Button
//           ElevatedButton.icon(
//             onPressed: _isRecording ? _stopRecording : _startRecording,
//             icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
//             label: Text(
//                 _isRecording ? "Stop Recording" : "Start Recording",
//                 style: TextStyle(fontSize: 18, color: Colors.white)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           // Switch Speaker Button
//           ElevatedButton(
//             onPressed: _switchSpeaker,
//             child: Text("Switch Speaker", style: TextStyle(fontSize: 18, color: Colors.white)),
//             style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
