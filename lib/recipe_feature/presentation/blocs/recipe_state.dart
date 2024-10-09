import 'package:ukla/core/errors/failure.dart';
import 'package:ukla/recipe_feature/data/models/step_data.dart';
import 'package:ukla/recipe_feature/domain/entities/fetched_recipe.dart';

import '../../domain/entities/recipe_entity.dart';
import 'package:video_player/video_player.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<RecipeEntity> recipes;

  RecipeLoaded({required this.recipes});
}
class RecipeVideoSelected extends RecipeState {

  RecipeVideoSelected();

  List<Object?> get props => [];
}

class RecipeStepsUpdated extends RecipeState {
  final List<StepData> steps;

  RecipeStepsUpdated(this.steps);

  List<Object?> get props => [steps];
}

class RecipeAdded extends RecipeState {}

class RecipeError extends RecipeState {
  final Failure failure;

  RecipeError({required this.failure});
}

class RecipeDetailsInitial extends RecipeState {}

class RecipeDetailsLoading extends RecipeState {}

class RecipeDetailsLoaded extends RecipeState {
  final FetchedRecipe recipe;
  final VideoPlayerController? videoController;
  final bool isPlaying;

   RecipeDetailsLoaded(this.recipe,this.videoController,{this.isPlaying = false});

  List<Object?> get props => [recipe];
}


class RecipeAddingLoading extends RecipeState {}

class RecipeDetailsError extends RecipeState {
  final String message;

  RecipeDetailsError(this.message);

  List<Object?> get props => [message];
}

