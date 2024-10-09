import 'package:flutter/material.dart';

class StepInput extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController instructionController;

  const StepInput({
    Key? key,
    required this.titleController,
    required this.instructionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step Title',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: 'Enter step title',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        const Text(
          'Step Instruction',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: instructionController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Enter step instruction',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
