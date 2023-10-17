import 'package:habbit_tracker_hive_db/date_time/date_time.dart';

import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("Habit_database");

class HabitDatabase {
  List todaysHabit = [];

  Map<DateTime, int> heatMapDataSet = {};

  //create initial default data----->
  void createDefaultData() {
    todaysHabit = [
      ["Read Book", false],
      ["Exercise", false],
    ];

    //first time opening the app then storing current date
    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load data if already exist---->
  void loadData() {
    // check if it is the new day, get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      // set it default/new list to add more for today
      todaysHabit = _myBox.get("CURRENT_HABIT_LIST");

      // set all habit to false since it is new day
      for (int i = 0; i < todaysHabit.length; i++) {
        todaysHabit[i][1] = false;
      }
    }

    // check if it is not new day, load todays list
    else {
      todaysHabit = _myBox.get(todaysDateFormatted());
    }
  }

//update the data---->
  void updateData() {
    //update today entry in database if user not clicked on previous date in map

    _myBox.put(todaysDateFormatted(), todaysHabit);
    print("here----> ${_myBox.get(todaysDateFormatted())}");

    // update universal habit list in case it changed (new habit, edit habit, delete habit)
    _myBox.put("CURRENT_HABIT_LIST", todaysHabit);

    // calculate the percentage--->
    calculatePercentage();

    //load the heat map---->
    loadHeatmap();
  }

  void calculatePercentage() {
    int countCompleted = 0;

    for (int i = 0; i < todaysHabit.length; i++) {
      if (todaysHabit[i][1] == true) countCompleted++;
    }

    String percent = todaysHabit.isEmpty
        ? "0.0"
        : (countCompleted / todaysHabit.length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0.0-1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatmap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(
          Duration(days: i),
        ),
      );

      double strengthPercentage =
          double.parse(_myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0");

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      //month
      int month = startDate.add(Duration(days: i)).month;

      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthPercentage).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
