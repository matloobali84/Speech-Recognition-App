import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'report_generator.dart';

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  // FlutterSound Recorder
  FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String _filePath = '';

  // Timers for each speaker
  int _speakerATime = 0;
  int _speakerBTime = 0;
  int _speakerASilence = 0;
  int _speakerBSilence = 0;
  int _interSpeakerSilence = 0; // Stores silence between speaker switches

  bool _isSpeakerA = true;

  // Audio waveform controller
  late RecorderController _waveformController;
  StreamSubscription? _recorderSubscription;
  Stopwatch _speakerAStopwatch = Stopwatch();
  Stopwatch _speakerBStopwatch = Stopwatch();
  Stopwatch _silenceStopwatch = Stopwatch();

  double silenceThreshold = 0.002; // Adjusted for better sensitivity

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _waveformController = RecorderController();
  }

  // Initialize recorder
  Future<void> _initializeRecorder() async {
    final dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/recorded_audio.aac';
    await _audioRecorder.openRecorder();
    await _audioRecorder.setSubscriptionDuration(Duration(milliseconds: 100));
  }

  // Start Recording
  void _startRecording() async {
    if (!_isRecording) {
      await _audioRecorder.startRecorder(
        toFile: _filePath,
        codec: Codec.aacADTS,
        sampleRate: 44100,
        bitRate: 64000,
        numChannels: 1,
        audioSource: AudioSource.microphone,
      );

      _isRecording = true;
      _monitorRecording(); // Start monitoring sound levels
      setState(() {});
    }
  }

  // Stop Recording
  void _stopRecording() async {
    if (_isRecording) {
      await _audioRecorder.stopRecorder();
      _isRecording = false;

      _speakerAStopwatch.stop();
      _speakerBStopwatch.stop();
      _silenceStopwatch.stop(); // Stop silence tracking when recording stops

      _recorderSubscription?.cancel();
      setState(() {});
    }
  }


  // Monitor audio levels
  void _monitorRecording() {
    _recorderSubscription = _audioRecorder.onProgress!.listen((event) {
      double amplitude = event.decibels ?? 0; // Handle null values safely

      print("Amplitude: $amplitude");

      if (amplitude >= 50.0) { // Speaking detected
        _silenceStopwatch.stop(); // Stop silence stopwatch but don't reset

        if (_isSpeakerA) {
          _speakerAStopwatch.start();
          _speakerBStopwatch.stop();
          _speakerATime = _speakerAStopwatch.elapsed.inSeconds;
        } else {
          _speakerBStopwatch.start();
          _speakerAStopwatch.stop();
          _speakerBTime = _speakerBStopwatch.elapsed.inSeconds;
        }
      }
      else if (amplitude >= 10.0 && amplitude <= 30.0) { // Silence detected
        _silenceStopwatch.start(); // Continue counting silence time

        if (_isSpeakerA) {
          _speakerASilence = _silenceStopwatch.elapsed.inSeconds;
        } else {
          _speakerBSilence = _silenceStopwatch.elapsed.inSeconds;
        }

        _speakerAStopwatch.stop();
        _speakerBStopwatch.stop();
      }

      setState(() {}); // Update UI
    });
  }


  // Switch Speaker
  void _switchSpeaker() {
    setState(() {
      // Capture silence before switching
      _interSpeakerSilence += _silenceStopwatch.elapsed.inSeconds;

      _isSpeakerA = !_isSpeakerA; // Switch the active speaker
      _silenceStopwatch.reset();  // Reset only for inter-speaker silence tracking

      if (_isSpeakerA) {
        _speakerBStopwatch.stop();
        _speakerAStopwatch.start();
      } else {
        _speakerAStopwatch.stop();
        _speakerBStopwatch.start();
      }
    });
  }


  // Format time
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    _recorderSubscription?.cancel();
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Recording Session"),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/recording.json', height: 120),
          const SizedBox(height: 10),
          Text("🎙️ Recording...",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Timer Display
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("🕒 A: ${_formatTime(_speakerATime)}",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text("🕒 B: ${_formatTime(_speakerBTime)}",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("🔕 Silence A: ${_formatTime(_speakerASilence)}",
                        style: TextStyle(fontSize: 14, color: Colors.orange)),
                    Text("🔕 Silence B: ${_formatTime(_speakerBSilence)}",
                        style: TextStyle(fontSize: 14, color: Colors.orange)),
                  ],
                ),
                Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: Center(
                          child: Text(
                            "🔕 Inter-Speaker Silence: ${_formatTime(_interSpeakerSilence)}",
                            style: TextStyle(fontSize: 14, color: Colors.green),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Start / Stop Button
          ElevatedButton.icon(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
            label: Text(
                _isRecording ? "Stop Recording" : "Start Recording",
                style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),

          // Switch Speaker Button
          ElevatedButton(
            onPressed: _switchSpeaker,
            child: Text("Switch Speaker", style: TextStyle(fontSize: 18, color: Colors.black)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportGeneratorScreen(
                    speakerATime: _speakerATime,
                    speakerBTime: _speakerBTime,
                    speakerASilence: _speakerASilence,
                    speakerBSilence: _speakerBSilence,
                    interSpeakerSwitchTime: _interSpeakerSilence, // Pass new value
                  ),
                ),
              );
            },
            icon: Icon(Icons.insert_chart, color: Colors.white), // Report icon
            label: Text("Report Generator", style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),



        ],
      ),
    );
  }
}
