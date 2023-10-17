import 'package:flutter/material.dart';

class EnterHabitDialog extends StatelessWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancle;

  const EnterHabitDialog(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text(
        "Enter Daily Habits 📝",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 12),
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            )),
      ),
      actions: [
        MaterialButton(
          onPressed: onCancle,
          color: Colors.white,
          child: const Text(
            "Cancle",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        MaterialButton(
          onPressed: onSave,
          color: Colors.blue.shade400,
          child: const Text(
            "Save",
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
