import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habbit_tracker_hive_db/database/habit_database.dart';
import 'package:habbit_tracker_hive_db/date_time/date_time.dart';

import 'package:habbit_tracker_hive_db/widgets/habit_dialog.dart';
import 'package:habbit_tracker_hive_db/widgets/habit_tile.dart';
import 'package:habbit_tracker_hive_db/widgets/monthly_summary.dart';
import 'package:habbit_tracker_hive_db/widgets/my_fab_buttton.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_database");

  bool isPrevious = false;
  String prevHabitDate = "";
  String noDataDate = "";

  final _controller = TextEditingController();

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      print(_myBox.get("CURRENT_HABIT_LIST"));
      db.loadData();
    }

    db.updateData();

    super.initState();
  }

  // checkbox clicked--->
  // if (isPrevious) {
  void clickedCheckBox({required int index, bool? value}) {
    setState(() {
      db.todaysHabit[index][1] = value ?? false;
    });

    db.updateData();
    // db.updateData(isPreviousList: isPrevious);
  }

  // create new habit--->
  void createNewHabit() {
    // show dialog to add habbit-->
    showDialog(
      context: context,
      builder: (context) => EnterHabitDialog(
        controller: _controller,
        onCancle: () => cancleHabit(),
        onSave: () => saveHabit(),
      ),
    );
  }

  // save habit----->
  void saveHabit() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        db.todaysHabit.add([_controller.text.toString(), false]);
      });
      // Clear the controller after use
      _controller.clear();
    }
    // close dialog box
    Navigator.pop(context);
    db.updateData();
    // db.updateData(isPreviousList: isPrevious);
  }

  void cancleHabit() {
    // when hit cancle after writting something then controller will clear that
    _controller.clear();

    // close dialog box
    Navigator.pop(context);
  }

  void editHabit(int index) {
    showDialog(
      context: context,
      builder: (context) => EnterHabitDialog(
        controller: _controller,
        onCancle: () => cancleHabit(),
        onSave: () => saveExistingHabit(index),
      ),
    );
    db.updateData();
    // db.updateData(isPreviousList: isPrevious);
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabit.removeAt(index);
    });
    db.updateData();
    // db.updateData(isPreviousList: isPrevious);
  }

  void saveExistingHabit(int index) {
    // edit the existing habit of perticular index
    // replace it with new controller value
    if (!isPrevious) {
      if (_controller.text.isNotEmpty) {
        setState(() {
          db.todaysHabit[index][0] = _controller.text;
        });
      }
      _controller.clear();
      Navigator.pop(context);
      db.updateData();
      // db.updateData(isPreviousList: isPrevious);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text(
          "Daily Habit Manager",
        ),
        elevation: 3.0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonthlySummary(
              dataset: db.heatMapDataSet,
              startDate: _myBox.get("START_DATE"),
              onTap: (value) {
                print(
                    "here Value --> ${convertDateTimeToString(value)} ---->\n${_myBox.get(convertDateTimeToString(value))}");

                if (_myBox.get(convertDateTimeToString(value)) == null) {
                  setState(() {
                    noDataDate = DateFormat('dd MMM yyyy').format(value);
                  });
                  getToastMessage(msg: "No Data available for $noDataDate");
                }
                if (convertDateTimeToString(value) != todaysDateFormatted()) {
                  isPrevious = true;

                  if (_myBox.get(convertDateTimeToString(value)) != null) {
                    db.todaysHabit = _myBox.get(convertDateTimeToString(value));
                    prevHabitDate = DateFormat('dd MMM yyyy').format(value);
                    setState(() {});
                  }
                } else {
                  isPrevious = false;
                  db.todaysHabit = _myBox.get(convertDateTimeToString(value));
                  setState(() {});
                }
              },
            ),
            const Divider(color: Colors.black54),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              child: Text(
                isPrevious
                    ? "Habit's List of $prevHabitDate"
                    : "Today's Daily Habit List",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todaysHabit.length,
                itemBuilder: (context, index) {
                  return HabitTileWidget(
                    onDeleteTapped: (context) {
                      if (isPrevious) {
                        getToastMessage();
                      } else {
                        deleteHabit(index);
                      }
                    },
                    onEditTapped: (context) {
                      if (isPrevious) {
                        getToastMessage();
                      } else {
                        editHabit(index);
                      }
                    },
                    habitName: db.todaysHabit[index][0],
                    isHabitCompleted: db.todaysHabit[index][1],
                    onChanged: (value) {
                      if (isPrevious) {
                        getToastMessage();
                      } else {
                        clickedCheckBox(index: index, value: value);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: MyFloatingActionButton(onChanged: () {
        if (isPrevious) {
          getToastMessage();
        } else {
          createNewHabit();
        }
      }),
    );
  }

  getToastMessage({String? msg = null}) {
    return Fluttertoast.showToast(
        msg: msg ?? "You cannot Add, Edit & Delete habit for $noDataDate !!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
