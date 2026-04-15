import 'package:hive/hive.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime time;

  @HiveField(2)
  final String label;

  @HiveField(3)
  bool isEnabled;

  AlarmModel({
    required this.id,
    required this.time,
    this.label = 'Wake Up',
    this.isEnabled = true,
  });
}
