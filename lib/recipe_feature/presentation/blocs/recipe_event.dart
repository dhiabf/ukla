import 'package:image_picker/image_picker.dart';
import 'package:ukla/recipe_feature/data/models/step_data.dart';

abstract class RecipeEvent {}

class FetchRecipesEvent extends RecipeEvent {}

class AddRecipeEvent extends RecipeEvent {
  final Map<String, dynamic> recipeData;
  final XFile video;

  AddRecipeEvent(this.recipeData, this.video);
}

class PickVideoEvent extends RecipeEvent {
  final XFile video;

  PickVideoEvent(this.video);

  List<Object> get props => [video];
}

class SelectVideoEvent extends RecipeEvent {
  final String videoPath;

  SelectVideoEvent(this.videoPath);

  List<Object?> get props => [videoPath];
}

class DeleteVideoEvent extends RecipeEvent {}

class UploadRecipeEvent extends RecipeEvent {
  final String title;

  UploadRecipeEvent(this.title);

  List<Object?> get props => [title];
}

class AddStepEvent extends RecipeEvent {
  final StepData step;

  AddStepEvent(this.step);

  List<Object?> get props => [step];
}

class PlayVideo extends RecipeEvent {}

class PauseVideo extends RecipeEvent {}

class FetchRecipeDetails extends RecipeEvent {
  final String recipeId;

  FetchRecipeDetails(this.recipeId);

  List<Object> get props => [recipeId];
}
