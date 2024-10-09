class RecipeEntity {
  final String recipeId;
  final String title;
  final int creatorId;
  final String videoUrl;
  final int duration;
  final DateTime createdAt;

  RecipeEntity({
    required this.recipeId,
    required this.title,
    required this.creatorId,
    required this.videoUrl,
    required this.duration,
    required this.createdAt,
  });
}
