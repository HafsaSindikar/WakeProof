import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakeproof/features/alarm/alarm_controller.dart';
import 'package:wakeproof/features/alarm/data/models/alarm_model.dart';
import 'package:wakeproof/features/alarm/data/alarm_local_source.dart';

class AlarmRingingScreen extends StatefulWidget {
  final AlarmModel alarm;

  const AlarmRingingScreen({super.key, required this.alarm});

  @override
  State<AlarmRingingScreen> createState() => _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends State<AlarmRingingScreen> {
  final AlarmController _alarmController = AlarmController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AlarmLocalSource _alarmSource = AlarmLocalSource();
  
  bool _isAwake = false;
  int _currentPrediction = 0; // 0 = Asleep, 1 = Transitional, 2 = Awake

  // Temporary web URL for testing
  final String _alarmSoundUrl = 'https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg';

  @override
  void initState() {
    super.initState();
    _startAlarm();
  }

  Future<void> _startAlarm() async {
    // 1. Play looping sound
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(UrlSource(_alarmSoundUrl));

    // 2. Start AI monitoring
    _alarmController.startMonitoring((prediction) {
      if (!mounted) return;
      
      setState(() {
        _currentPrediction = prediction;
        if (prediction == 2 && !_isAwake) {
          _isAwake = true;
          _audioPlayer.stop(); // Stop alarm when awake detected
        }
      });
    });
  }

  Future<void> _dismissAlarm() async {
    // Turn off the alarm in database explicitly
    await _alarmSource.setAlarmEnabled(widget.alarm.id, false);
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _alarmController.stopMonitoring();
    _audioPlayer.dispose();
    super.dispose();
  }

  String _getPredictionText() {
    switch (_currentPrediction) {
      case 0:
        return "You seem to be ASLEEP. Shake your phone!";
      case 1:
        return "You're waking up... keep moving!";
      case 2:
        return "AWAKE! Good morning!";
      default:
        return "Analyzing...";
    }
  }

  Color _getBackgroundColor() {
    if (_isAwake) return Colors.green.shade100;
    return Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isAwake ? Icons.wb_sunny_rounded : Icons.alarm_rounded,
                size: 100,
                color: _isAwake ? Colors.green.shade700 : Colors.red.shade700,
              ),
              const SizedBox(height: 32),
              Text(
                TimeOfDay.fromDateTime(widget.alarm.time).format(context),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isAwake ? Colors.green.shade900 : Colors.red.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.alarm.label,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: _isAwake ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      "AI Status",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getPredictionText(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: FilledButton(
                  onPressed: _isAwake ? _dismissAlarm : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Text(
                    _isAwake ? 'Dismiss Alarm' : 'Wake up to Dismiss',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
