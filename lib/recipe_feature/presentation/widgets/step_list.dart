import 'package:flutter/material.dart';
import 'package:ukla/recipe_feature/data/models/step_data.dart';

class StepList extends StatelessWidget {
  final List<StepData> steps;

  const StepList({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(steps[index].stepTitle),
          subtitle: Text(steps[index].instructions),
          tileColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }
}
