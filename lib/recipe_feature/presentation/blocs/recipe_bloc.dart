import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukla/core/errors/failure.dart';
import 'package:ukla/recipe_feature/domain/use_cases/fetch_recipe.dart';
import 'package:video_player/video_player.dart';
import '../../domain/use_cases/fetch_recipes.dart';
import '../../domain/use_cases/upload_recipe.dart';
import '../blocs/recipe_event.dart';
import '../blocs/recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final FetchRecipes fetchRecipes;
  final UploadRecipe uploadRecipe;
  final FetchRecipe fetchRecipe;

  RecipeBloc(
      {required this.fetchRecipes,
      required this.uploadRecipe,
      required this.fetchRecipe})
      : super(RecipeInitial()) {
    on<FetchRecipesEvent>((event, emit) async {
      emit(RecipeLoading());
      try {
        final recipes = await fetchRecipes.call();
        emit(RecipeLoaded(recipes: recipes));
      } catch (error) {
        emit(RecipeError(failure: Failure(error.toString())));
      }
    });
    on<AddRecipeEvent>((event, emit) async {
      emit(RecipeLoading());
      try {
        await uploadRecipe.call(event.recipeData);
        emit(RecipeAdded());
      } catch (error) {
        emit(RecipeError(failure: Failure(error.toString())));
      }
    });
    on<FetchRecipeDetails>((event, emit) async {
      emit(RecipeDetailsLoading());
      try {
        final recipe = await fetchRecipe.call(event.recipeId);
        final videoController = VideoPlayerController.network(recipe.videoUrl);
        await videoController.initialize();
        emit(RecipeDetailsLoaded(recipe, videoController));
      } catch (error) {
        emit(RecipeError(failure: Failure(error.toString())));
      }
    });
    on<SelectVideoEvent>((event, emit) {
      emit(RecipeVideoSelected());
    });
    on<PlayVideo>((event, emit) {
      if (state is RecipeDetailsLoaded) {
        final controller = (state as RecipeDetailsLoaded).videoController;
        controller?.play();
        emit(RecipeDetailsLoaded(
          (state as RecipeDetailsLoaded).recipe,
          controller,
          isPlaying: true,
        ));
      }
    });
    on<PauseVideo>((event, emit) {
      if (state is RecipeDetailsLoaded) {
        final controller = (state as RecipeDetailsLoaded).videoController;
        controller?.pause();
        emit(RecipeDetailsLoaded(
          (state as RecipeDetailsLoaded).recipe,
          controller,
          isPlaying: false,
        ));
      }
    });
  }
}
