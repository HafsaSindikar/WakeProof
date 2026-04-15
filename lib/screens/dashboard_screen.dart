import 'package:flutter/material.dart';

class AlarmItem {
  final TimeOfDay time;
  final String label;
  final bool isEnabled;

  AlarmItem({
    required this.time,
    this.label = 'Wake Up',
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
                    'No alarms yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to start your day right',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurfaceVariant,
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
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: alarm.isEnabled
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: alarm.isEnabled
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () => _toggleAlarm(index, !alarm.isEnabled),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alarm.time.format(context),
                                  style: TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -1.5,
                                    color: alarm.isEnabled
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  alarm.label,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: alarm.isEnabled
                                        ? colorScheme.onPrimaryContainer.withOpacity(0.8)
                                        : colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  color: alarm.isEnabled
                                      ? colorScheme.onPrimaryContainer.withOpacity(0.6)
                                      : colorScheme.onSurface.withOpacity(0.4),
                                  tooltip: 'Delete',
                                  onPressed: () => _deleteAlarm(index),
                                ),
                                Switch(
                                  value: alarm.isEnabled,
                                  onChanged: (value) => _toggleAlarm(index, value),
                                ),
                              ],
                            ),
                          ],
                        ),
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
