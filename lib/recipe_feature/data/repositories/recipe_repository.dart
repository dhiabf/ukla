import 'package:ukla/recipe_feature/domain/entities/fetched_recipe.dart';
import 'package:ukla/recipe_feature/domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository_interface.dart';
import '../data_sources/recipe_data_source.dart';
import '../models/recipe_model.dart';

class RecipeRepository implements RecipeRepositoryInterface {
  final RecipeDataSource dataSource;

  RecipeRepository({required this.dataSource});

  @override
  Future<List<RecipeEntity>> fetchRecipes() async {
    List<RecipeModel> recipes = await dataSource.fetchRecipes();
    return recipes.map((recipe) => recipe.toEntity()).toList();
  }

  @override
  Future<FetchedRecipe> getRecipeById(String id) async {
    return await dataSource.fetchRecipeById(id);
  }

  @override
  Future<void> uploadRecipe(Map<String, dynamic> recipeData) async {
    await dataSource.uploadRecipe(recipeData);
  }
}
