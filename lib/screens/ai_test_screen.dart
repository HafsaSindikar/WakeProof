import 'package:flutter/material.dart';
import '../features/alarm/alarm_controller.dart';

class AiTestScreen extends StatefulWidget {
  const AiTestScreen({super.key});

  @override
  State<AiTestScreen> createState() => _AiTestScreenState();
}

class _AiTestScreenState extends State<AiTestScreen> {
  final AlarmController _controller = AlarmController();
  String _statusText = "Initializing...";
  IconData _statusIcon = Icons.hourglass_empty;
  Color _statusColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    // Start the AI monitoring as soon as the screen opens
    _controller.startMonitoring((prediction) {
      setState(() {
        if (prediction == 0) {
          _statusText = "User is ASLEEP";
          _statusIcon = Icons.bedtime;
          _statusColor = Colors.blue;
        } else if (prediction == 1) {
          _statusText = "USER MOVING";
          _statusIcon = Icons.transfer_within_a_station;
          _statusColor = Colors.orange;
        } else {
          _statusText = "USER IS AWAKE!";
          _statusIcon = Icons.directions_run;
          _statusColor = Colors.green;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.stopMonitoring(); // Clean up to save battery
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _statusColor.withOpacity(0.1),
      appBar: AppBar(title: const Text("WakeProof AI Monitor")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_statusIcon, size: 100, color: _statusColor),
            const SizedBox(height: 20),
            Text(
              _statusText,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _statusColor),
            ),
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "Keep the phone still for 'Asleep'.\nShake or walk around for 'Awake'.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}