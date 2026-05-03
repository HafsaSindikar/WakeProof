import 'dart:math';
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  Interpreter? _interpreter;

  // 1. Connect to the "Brain" file
  Future<void> loadModel() async {
    try {
      // This matches the path we put in pubspec.yaml
      _interpreter = await Interpreter.fromAsset('assets/wakeproof_model.tflite');
      print("🚀 AI Model Loaded Successfully");
    } catch (e) {
      print("❌ Failed to load model: $e");
    }
  }

  // 2. Math Helper: Calculates "Shakiness" (Standard Deviation)
  // This is the EXACT same math we used in Python!
  double calculateStdDev(List<double> data) {
    if (data.isEmpty) return 0.0;
    double mean = data.reduce((a, b) => a + b) / data.length;
    double variance = data.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / data.length;
    return sqrt(variance);
  }

  // 3. The Prediction: 0 = Asleep, 1 = Transitional, 2 = Awake
  int predict(List<double> xData, List<double> yData, List<double> zData) {
    if (_interpreter == null) {
      print("⚠️ Model not loaded yet!");
      return 0;
    }

    // Prepare our 4 Features: StdDev X, Y, Z and Mean Z (Tilt)
    double stdX = calculateStdDev(xData);
    double stdY = calculateStdDev(yData);
    double stdZ = calculateStdDev(zData);
    double meanZ = zData.reduce((a, b) => a + b) / zData.length;

    // Input shape [1, 4] as expected by your model
    var input = [[stdX, stdY, stdZ, meanZ]];
    
    // Output shape [1, 3] for our 3 classes
    var output = List.filled(1 * 3, 0.0).reshape([1, 3]);

    // Run the AI logic
    _interpreter!.run(input, output);

    // Get the result (find which index has the highest probability)
    List<double> probabilities = output[0];
    
    // Logic: Which is higher? index 0, 1, or 2?
    double maxVal = probabilities.reduce(max);
    return probabilities.indexOf(maxVal);
  }

  void dispose() {
    _interpreter?.close();
  }
}
