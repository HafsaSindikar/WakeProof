import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../core/ml_service.dart'; // Make sure this path matches your folder

class AlarmController {
  final MLService _mlService = MLService();
  StreamSubscription? _accelerometerSubscription;
  
  // These "Buffers" store the sensor readings for about 4 seconds
  final List<double> _xBuffer = [];
  final List<double> _yBuffer = [];
  final List<double> _zBuffer = [];

  // Keeps track of the last 10 predictions for "Sliding Window" voting
  final List<int> _predictionHistory = [];

  // This starts the AI tracking
  void startMonitoring(Function(int) onResult) async {
    // Clear any leftover data
    _xBuffer.clear();
    _yBuffer.clear();
    _zBuffer.clear();
    _predictionHistory.clear();

    // First, wake up the AI brain
    await _mlService.loadModel();

    // Start listening to the phone's user accelerometer (filters out gravity)
    _accelerometerSubscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _xBuffer.add(event.x);
      _yBuffer.add(event.y);
      _zBuffer.add(event.z);

      // Once we have 400 readings (about 4 seconds of movement)
      if (_xBuffer.length >= 400) {
        // Ask the AI: "What is the user doing?"
        int prediction = _mlService.predict(_xBuffer, _yBuffer, _zBuffer);
        
        // Add to history and keep only the last 10 for voting
        _predictionHistory.add(prediction);
        if (_predictionHistory.length > 10) {
          _predictionHistory.removeAt(0);
        }

        // Sliding Window logic: If 3 or more of the last 10 predictions 
        // were 1 (Moving) or 2 (Awake), mark the user as 'Awake' (2).
        int activeCount = _predictionHistory.where((p) => p == 1 || p == 2).length;
        
        int finalResult = 0;
        if (activeCount >= 3) {
          finalResult = 2; // Trigger dismissal
        } else {
          finalResult = 0; // Still asleep
        }
        
        // Send the answer back to the UI
        onResult(finalResult);

        // Clear the buffers to start the next window
        _xBuffer.clear();
        _yBuffer.clear();
        _zBuffer.clear();
      }
    });
  }

  // Stop everything to save battery
  void stopMonitoring() {
    _accelerometerSubscription?.cancel();
    _mlService.dispose();
  }
}