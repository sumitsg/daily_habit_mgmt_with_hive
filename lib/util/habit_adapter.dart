import 'package:hive_flutter/hive_flutter.dart';
part 'habit_adapter.g.dart';

@HiveType(typeId: 10, adapterName: "DailyHabitAdapter")
class DailyHabit extends HiveObject {
  @HiveField(0)
  String habiName;
  @HiveField(1)
  bool isCompleted;

  DailyHabit({required this.habiName, required this.isCompleted});
}
