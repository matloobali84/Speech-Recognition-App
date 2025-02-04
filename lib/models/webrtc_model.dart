
//
// class WebRTCModel {
//   late MediaStream _mediaStream;
//   late MediaStreamTrack _audioTrack;
//   late RTCVideoRenderer _renderer;
//   List<double> _speechLevels = [];
//   late Timer _audioLevelTimer;
//   late final RTCPeerConnection _peerConnection;
//
//   WebRTCModel();
//
//   // Initialize WebRTC and get the audio stream
//   Future<void> startStream() async {
//     try {
//       print("Requesting microphone access...");
//       final stream = await navigator.mediaDevices.getUserMedia({'audio': true});
//       _mediaStream = stream;
//       print("Media stream obtained.");
//
//       _audioTrack = _mediaStream.getAudioTracks()[0];
//       print("Audio track obtained.");
//
//       _peerConnection = await createPeerConnection({});
//       _peerConnection.addTrack(_audioTrack);
//       print("Peer connection established.");
//     } catch (e) {
//       print("Error in startStream: $e");
//     }
//   }
//
//   // Start tracking audio levels in real time
//   void startTrackingAudioLevels() {
//     _audioLevelTimer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
//       try {
//         final stats = await _peerConnection.getStats();
//         if (stats.isEmpty) return;
//
//         for (var report in stats) {
//           if (report.type == 'inbound-rtp' && report.values.containsKey('audioLevel')) {
//             double audioLevel = report.values['audioLevel'] ?? 0.0;
//             _speechLevels.add(audioLevel);
//           }
//         }
//       } catch (e) {
//         print('Error getting audio stats: $e');
//       }
//     });
//     print("Started tracking audio levels...");
//   }
//
//   List<double> getSpeechLevels() {
//     return _speechLevels;
//   }
//
//   void stopTrackingAudioLevels() {
//     _audioLevelTimer.cancel();
//     print("Stopped tracking audio levels.");
//   }
//
//   // Stop the media stream and peer connection when done
//   void stopStream() {
//     if (_audioTrack != null) {
//       _audioTrack.stop();
//     }
//     _peerConnection.close();
//   }
// }
 import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
class WebRTCModel {
  static final WebRTCModel _instance = WebRTCModel._internal();
  factory WebRTCModel() => _instance;
  WebRTCModel._internal();

  bool isSpeakingA = false;
  bool isSpeakingB = false;
  int speakingTimeA = 0;
  int speakingTimeB = 0;
  int silenceTimeA = 0;
  int silenceTimeB = 0;
  int conversationTime = 0;

  Stopwatch speakerAStopwatch = Stopwatch();
  Stopwatch speakerBStopwatch = Stopwatch();
  Stopwatch silenceStopwatch = Stopwatch();

  // Start speech detection for Speaker A
  void startSpeechDetectionForSpeakerA() {
    isSpeakingA = true;
    speakerAStopwatch.start();
    speakerBStopwatch.stop();
    silenceStopwatch.stop();
  }

  // Stop speech detection for Speaker A
  void stopSpeechDetectionForSpeakerA() {
    isSpeakingA = false;
    speakerAStopwatch.stop();
    silenceTimeA += speakerAStopwatch.elapsedMilliseconds;
    speakingTimeA += speakerAStopwatch.elapsedMilliseconds;
    speakerAStopwatch.reset();
    conversationTime += speakingTimeA;
  }

  // Start speech detection for Speaker B
  void startSpeechDetectionForSpeakerB() {
    isSpeakingB = true;
    speakerBStopwatch.start();
    speakerAStopwatch.stop();
    silenceStopwatch.stop();
  }

  // Stop speech detection for Speaker B
  void stopSpeechDetectionForSpeakerB() {
    isSpeakingB = false;
    speakerBStopwatch.stop();
    silenceTimeB += speakerBStopwatch.elapsedMilliseconds;
    speakingTimeB += speakerBStopwatch.elapsedMilliseconds;
    speakerBStopwatch.reset();
    conversationTime += speakingTimeB;
  }

  // Update speaking time and silence time based on speech detection
  void updateTimers(bool isSpeakingA, bool isSpeakingB, double audioLevel) {
    if (audioLevel > 0.05) { // Detected speech above the threshold
      if (isSpeakingA) {
        if (!speakerAStopwatch.isRunning) speakerAStopwatch.start();
      } else if (isSpeakingB) {
        if (!speakerBStopwatch.isRunning) speakerBStopwatch.start();
      }

      if (silenceStopwatch.isRunning) {
        silenceStopwatch.stop();
        if (isSpeakingA) {
          silenceTimeA += silenceStopwatch.elapsedMilliseconds;
        } else if (isSpeakingB) {
          silenceTimeB += silenceStopwatch.elapsedMilliseconds;
        }
        silenceStopwatch.reset();
      }
    } else {  // Detected silence
      if (speakerAStopwatch.isRunning || speakerBStopwatch.isRunning) {
        silenceStopwatch.start();
      }
    }
  }

  // Reset timers
  void resetTimers() {
    speakingTimeA = 0;
    speakingTimeB = 0;
    silenceTimeA = 0;
    silenceTimeB = 0;
    conversationTime = 0;
    speakerAStopwatch.reset();
    speakerBStopwatch.reset();
    silenceStopwatch.reset();
  }
}
