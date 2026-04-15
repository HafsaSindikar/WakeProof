import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wakeproof/features/alarm/data/alarm_local_source.dart';
import 'package:wakeproof/features/alarm/data/models/alarm_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AlarmLocalSource _alarmSource = AlarmLocalSource();

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
      final now = DateTime.now();
      var alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      
      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(const Duration(days: 1));
      }
      
      await _alarmSource.addAlarm(alarmTime);
    }
  }

  void _toggleAlarm(String id) {
    _alarmSource.toggleAlarm(id);
  }

  void _deleteAlarm(String id) {
    _alarmSource.deleteAlarm(id);
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
      body: ValueListenableBuilder<Box<AlarmModel>>(
        valueListenable: _alarmSource.listenable(),
        builder: (context, box, child) {
          final alarms = box.values.toList();
          alarms.sort((a, b) => a.time.compareTo(b.time));

          return alarms.isEmpty
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
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
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
                      onTap: () => _toggleAlarm(alarm.id),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  TimeOfDay.fromDateTime(alarm.time).format(context),
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
                                  onPressed: () => _deleteAlarm(alarm.id),
                                ),
                                Switch(
                                  value: alarm.isEnabled,
                                  onChanged: (value) => _toggleAlarm(alarm.id),
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
