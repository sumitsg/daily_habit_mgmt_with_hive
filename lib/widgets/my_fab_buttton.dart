import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Function() onChanged;
  const MyFloatingActionButton({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onChanged,
      child: const Icon(Icons.add),
      backgroundColor: Colors.grey.shade800,
    );
  }
}
