import '../repositories/recipe_repository_interface.dart';

class UploadRecipe {
  final RecipeRepositoryInterface repository;

  UploadRecipe(this.repository);

  Future<void> call(Map<String, dynamic> recipeData) async {
    await repository.uploadRecipe(recipeData);
  }
}
