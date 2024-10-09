import 'package:ukla/recipe_feature/domain/entities/fetched_recipe.dart';
import '../repositories/recipe_repository_interface.dart';

class FetchRecipe {
  final RecipeRepositoryInterface repository;

  FetchRecipe(this.repository);

  Future<FetchedRecipe> call(String recipeId) async {
    return await repository.getRecipeById(recipeId);
  }
}
