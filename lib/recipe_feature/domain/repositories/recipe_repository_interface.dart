import 'package:ukla/recipe_feature/domain/entities/fetched_recipe.dart';
import '../entities/recipe_entity.dart';

abstract class RecipeRepositoryInterface {
  Future<List<RecipeEntity>> fetchRecipes();

  Future<FetchedRecipe> getRecipeById(String id);

  Future<void> uploadRecipe(Map<String, dynamic> recipeData);
}
