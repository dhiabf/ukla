class FetchedRecipe {
  final String recipeId;
  final String title;
  final int creatorId;
  final String videoUrl;
  final int duration;
  final DateTime createdAt;
  final List<RecipeStep> steps;

  FetchedRecipe({
    required this.recipeId,
    required this.title,
    required this.creatorId,
    required this.videoUrl,
    required this.duration,
    required this.createdAt,
    required this.steps,
  });

  factory FetchedRecipe.fromJson(Map<String, dynamic> json) {
    return FetchedRecipe(
      recipeId: json['recipe']['recipe_id'],
      title: json['recipe']['title'],
      creatorId: json['recipe']['creator_id'],
      videoUrl: json['recipe']['video_url'],
      duration: json['recipe']['duration'],
      createdAt: DateTime.parse(json['recipe']['created_at']),
      steps: (json['steps'] as List)
          .map((step) => RecipeStep.fromJson(step))
          .toList(),
    );
  }
}


class RecipeStep {
  final int stepNumber;
  final String instructions;
  final String title;

  RecipeStep({required this.stepNumber, required this.instructions, required this.title});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      stepNumber: json['step_number'],
      instructions: json['instructions'],
      title: json['step_title'],

    );
  }
}
