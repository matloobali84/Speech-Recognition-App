// import 'package:flutter/material.dart';
//
// class ReportGeneratorScreen extends StatelessWidget {
//   final int speakerATime;  // Time spoken by Speaker A
//   final int speakerBTime;  // Time spoken by Speaker B
//   final int speakerASilence;  // Silence time for Speaker A
//   final int speakerBSilence;  // Silence time for Speaker B
//   final int interSpeakerSwitchTime;  // Time spent switching between speakers
//
//   ReportGeneratorScreen({
//     required this.speakerATime,
//     required this.speakerBTime,
//     required this.speakerASilence,
//     required this.speakerBSilence,
//     required this.interSpeakerSwitchTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // Calculations
//     int STA = speakerASilence; // Silence time for Speaker A
//     int STB = speakerBSilence; // Silence time for Speaker B
//     int ISS = interSpeakerSwitchTime; // Inter-speaker silence time
//     int WTA = speakerATime; // Time spoken by Speaker A
//     int WTB = speakerBTime; // Time spoken by Speaker B
//
//     // Conversation times
//     int CTA = WTA + STA; // Conversation time of Speaker A
//     int CTB = WTB + STB; // Conversation time of Speaker B
//
//     // Total silence time
//     int TST = STA + STB + ISS; // Total Silence Time
//
//     // Total conversation time
//     int TCT = CTA + ISS + CTB; // Total Conversation Time
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text("Report Generator"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView(
//           children: [
//             // Header
//             Text(
//               "🎙️ Conversation Report",
//               style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             Divider(color: Colors.redAccent),
//             SizedBox(height: 20),
//
//             // Report Details
//             _buildReportRow("STA (Silence Time A):", STA),
//             _buildReportRow("STB (Silence Time B):", STB),
//             _buildReportRow("ISS (Inter-Speaker Silence):", ISS),
//             _buildReportRow("TST (Total Silence Time):", TST),
//             SizedBox(height: 20),
//
//             _buildReportRow("WTA (Time Spoken A):", WTA),
//             _buildReportRow("WTB (Time Spoken B):", WTB),
//             _buildReportRow("CTA (Conversation Time A):", CTA),
//             _buildReportRow("CTB (Conversation Time B):", CTB),
//             _buildReportRow("TCT (Total Conversation Time):", TCT),
//
//             // Spacer
//             SizedBox(height: 40),
//
//             // Back Button
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.pop(context); // Go back to the previous screen
//               },
//               icon: Icon(Icons.arrow_back, color: Colors.white),
//               label: Text("Back to Recording Screen",
//                   style: TextStyle(fontSize: 18, color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper function to display report rows
//   Widget _buildReportRow(String label, int value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 18, color: Colors.white),
//           ),
//           Text(
//             "$value s",
//             style: TextStyle(
//                 fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ReportGeneratorScreen extends StatelessWidget {
  final int speakerATime;  // Time spoken by Speaker A
  final int speakerBTime;  // Time spoken by Speaker B
  final int speakerASilence;  // Silence time for Speaker A
  final int speakerBSilence;  // Silence time for Speaker B
  final int interSpeakerSwitchTime;  // Time spent switching between speakers

  ReportGeneratorScreen({
    required this.speakerATime,
    required this.speakerBTime,
    required this.speakerASilence,
    required this.speakerBSilence,
    required this.interSpeakerSwitchTime,
  });

  @override
  Widget build(BuildContext context) {
    // Calculations
    int STA = speakerASilence; // Silence time for Speaker A
    int STB = speakerBSilence; // Silence time for Speaker B
    int ISS = interSpeakerSwitchTime; // Inter-speaker silence time
    int WTA = speakerATime; // Time spoken by Speaker A
    int WTB = speakerBTime; // Time spoken by Speaker B

    // Conversation times
    int CTA = WTA + STA; // Conversation time of Speaker A
    int CTB = WTB + STB; // Conversation time of Speaker B

    // Total silence time
    int TST = STA + STB + ISS; // Total Silence Time

    // Total conversation time
    int TCT = CTA + ISS + CTB; // Total Conversation Time

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Report Generator"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 20),// Make the screen scrollable

        child: Column(
          children: [
            // Header
            Text(
              "🎙️ Conversation Report",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Divider(color: Colors.redAccent),
            SizedBox(height: 20),

            // Report Details
            _buildReportRow("STA (Silence Time A):", STA),
            _buildReportRow("STB (Silence Time B):", STB),
            _buildReportRow("ISS (Inter-Speaker Silence):", ISS),
            _buildReportRow("TST (Total Silence Time):", TST),
            SizedBox(height: 20),

            _buildReportRow("WTA (Time Spoken A):", WTA),
            _buildReportRow("WTB (Time Spoken B):", WTB),
            _buildReportRow("CTA (Conversation Time A):", CTA),
            _buildReportRow("CTB (Conversation Time B):", CTB),
            _buildReportRow("Total Conversation Time:", TCT),

            // Spacer
            SizedBox(height: 40),

            // Back Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
              label: Text("Back to Recording Screen",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to display report rows
  Widget _buildReportRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            "$value s",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}
