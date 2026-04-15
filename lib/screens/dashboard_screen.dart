import 'package:flutter/material.dart';

class AlarmItem {
  final TimeOfDay time;
  final String label;
  final bool isEnabled;

  AlarmItem({
    required this.time,
    this.label = 'Alarm',
    this.isEnabled = true,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<AlarmItem> _alarms = [];

  Future<void> _addAlarm() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _alarms.add(AlarmItem(time: pickedTime));
        // Sort alarms by time
        _alarms.sort((a, b) {
          if (a.time.hour != b.time.hour) {
            return a.time.hour.compareTo(b.time.hour);
          }
          return a.time.minute.compareTo(b.time.minute);
        });
      });
    }
  }

  void _toggleAlarm(int index, bool value) {
    setState(() {
      final alarm = _alarms[index];
      _alarms[index] = AlarmItem(
        time: alarm.time,
        label: alarm.label,
        isEnabled: value,
      );
    });
  }

  void _deleteAlarm(int index) {
    setState(() {
      _alarms.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('WakeProof'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _alarms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm_off_rounded,
                    size: 80,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No alarms set',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add one',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onLongPress: () => _deleteAlarm(index),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alarm.time.format(context),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w300,
                                  color: alarm.isEnabled
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                alarm.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: alarm.isEnabled
                                      ? colorScheme.onSurfaceVariant
                                      : colorScheme.onSurfaceVariant.withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: alarm.isEnabled,
                            onChanged: (value) => _toggleAlarm(index, value),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAlarm,
        icon: const Icon(Icons.add),
        label: const Text('Add Alarm'),
        elevation: 2,
      ),
    );
  }
}
