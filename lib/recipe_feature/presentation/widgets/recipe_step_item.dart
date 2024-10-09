import 'package:flutter/material.dart';

class RecipeStepItem extends StatelessWidget {
  final int stepNumber;
  final String stepTitle;
  final String instructions;

  const RecipeStepItem({Key? key, required this.stepNumber, required this.instructions,required this.stepTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Step $stepNumber $stepTitle'),
      subtitle: Text(instructions),
    );
  }
}
