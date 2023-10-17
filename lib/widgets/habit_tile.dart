import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTileWidget extends StatelessWidget {
  final String habitName;
  final bool? isHabitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext) onEditTapped;
  final Function(BuildContext) onDeleteTapped;
  const HabitTileWidget(
      {super.key,
      required this.habitName,
      required this.isHabitCompleted,
      required this.onChanged,
      required this.onEditTapped,
      required this.onDeleteTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: onEditTapped,
              label: "Edit",
              icon: Icons.edit_note,
              backgroundColor: Colors.green,
              autoClose: true,
              borderRadius: BorderRadius.circular(8),
              spacing: 10,
            ),
            SlidableAction(
              onPressed: onDeleteTapped,
              label: "Delete",
              icon: Icons.delete,
              autoClose: true,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(8),
              spacing: 10,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isHabitCompleted! ? Colors.green.shade300 : Colors.white,
          ),
          child: Row(children: [
            // checkbox for habit ---->
            Checkbox(
              value: isHabitCompleted,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),

            const SizedBox(width: 10),

            // habit name --->
            Text(habitName),

            const Spacer(),

            Icon(
              Icons.arrow_back,
              color: isHabitCompleted! ? Colors.white : Colors.black,
            )
          ]),
        ),
      ),
    );
  }
}
