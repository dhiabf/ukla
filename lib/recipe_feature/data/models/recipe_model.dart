import 'package:ukla/recipe_feature/domain/entities/recipe_entity.dart';

class RecipeModel {
  final String recipeId;
  final String title;
  final int creatorId;
  final String videoUrl;
  final int duration;
  final DateTime createdAt;

  RecipeModel({
    required this.recipeId,
    required this.title,
    required this.creatorId,
    required this.videoUrl,
    required this.duration,
    required this.createdAt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      recipeId: json['recipe_id'],
      title: json['title'],
      creatorId: json['creator_id'],
      videoUrl: json['video_url'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipe_id': recipeId,
      'title': title,
      'creator_id': creatorId,
      'video_url': videoUrl,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
    };
  }

  RecipeEntity toEntity() {
    return RecipeEntity(
      recipeId: recipeId,
      title: title,
      creatorId: creatorId,
      videoUrl: videoUrl,
      duration: duration,
      createdAt: createdAt,
    );
  }
}
