import 'package:flutter/material.dart';
// import 'package:habbit_tracker_hive_db/database/habit_database.dart' as db;
import 'package:habbit_tracker_hive_db/pages/home_page.dart';
import 'package:habbit_tracker_hive_db/util/habit_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await path_provider.getApplicationDocumentsDirectory();

  //initialize hive

  await Hive.initFlutter(document.path);
  // Hive.registerAdapter(DailyHabitAdapter());

  // open box
  await Hive.openBox("Habit_database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
