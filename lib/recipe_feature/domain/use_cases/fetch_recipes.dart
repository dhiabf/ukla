import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository_interface.dart';

class FetchRecipes {
  final RecipeRepositoryInterface repository;

  FetchRecipes(this.repository);

  Future<List<RecipeEntity>> call() async {
    return await repository.fetchRecipes();
  }
}
