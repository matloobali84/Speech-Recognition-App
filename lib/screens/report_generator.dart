import 'package:flutter/material.dart';

class ReportGeneratorScreen extends StatefulWidget {
  final int speakerATime; // Time spoken by Speaker A
  final int speakerBTime; // Time spoken by Speaker B
  final int speakerASilence; // Silence time for Speaker A
  final int speakerBSilence; // Silence time for Speaker B
  final int interSpeakerSwitchTime; // Time spent switching between speakers

  const ReportGeneratorScreen({
    Key? key,
    required this.speakerATime,
    required this.speakerBTime,
    required this.speakerASilence,
    required this.speakerBSilence,
    required this.interSpeakerSwitchTime,
  }) : super(key: key);

  @override
  _ReportGeneratorScreenState createState() => _ReportGeneratorScreenState();
}

class _ReportGeneratorScreenState extends State<ReportGeneratorScreen> {
  late int STA;
  late int STB;
  late int ISS;
  late int WTA;
  late int WTB;
  late int CTA;
  late int CTB;
  late int TST;
  late int TCT;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    STA = widget.speakerASilence;
    STB = widget.speakerBSilence;
    ISS = widget.interSpeakerSwitchTime;
    WTA = widget.speakerATime;
    WTB = widget.speakerBTime;
    CTA = WTA + STA;
    CTB = WTB + STB;
    TST = STA + STB + ISS;
    TCT = CTA + ISS + CTB;
  }

  void _resetReport() {
    setState(() {
      STA = 0;
      STB = 0;
      ISS = 0;
      WTA = 0;
      WTB = 0;
      CTA = 0;
      CTB = 0;
      TST = 0;
      TCT = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Report Generator"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05), // Responsive padding
        child: Column(
          children: [
            const Text(
              "🎙️ Conversation Report",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.redAccent),
            const SizedBox(height: 20),

            _buildReportRow("STA (Silence Time A):", STA),
            _buildReportRow("STB (Silence Time B):", STB),
            _buildReportRow("ISS (Inter-Speaker Silence):", ISS),
            _buildReportRow("TST (Total Silence Time):", TST),
            const SizedBox(height: 20),

            _buildReportRow("WTA (Time Spoken A):", WTA),
            _buildReportRow("WTB (Time Spoken B):", WTB),
            _buildReportRow("CTA (Conversation Time A):", CTA),
            _buildReportRow("CTB (Conversation Time B):", CTB),
            _buildReportRow("Total Conversation Time:", TCT),

            const SizedBox(height: 25),

            // Back Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text("Back to Recording Screen",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: 12), // Responsive padding
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 10),

            // Reset Button
            ElevatedButton.icon(
              onPressed: _resetReport,
              icon: const Icon(Icons.restart_alt, color: Colors.white),
              label: const Text("Reset Report",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: 15), // Responsive padding
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
          Text(label,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
          Text("$value s",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent)),
        ],
      ),
    );
  }
}
