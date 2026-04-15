import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'models/alarm_model.dart';

class AlarmLocalSource {
  static const String boxName = 'alarms';
  final _uuid = const Uuid();

  Box<AlarmModel> get _box => Hive.box<AlarmModel>(boxName);

  ValueListenable<Box<AlarmModel>> listenable() {
    return _box.listenable();
  }

  List<AlarmModel> getAlarms() {
    return _box.values.toList();
  }

  Future<void> addAlarm(DateTime time) async {
    final alarm = AlarmModel(
      id: _uuid.v4(),
      time: time,
    );
    await _box.put(alarm.id, alarm);
  }

  Future<void> deleteAlarm(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleAlarm(String id) async {
    final alarm = _box.get(id);
    if (alarm != null) {
      alarm.isEnabled = !alarm.isEnabled;
      await alarm.save();
    }
  }
}
