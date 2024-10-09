import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'recipe_feature/data/data_sources/recipe_data_source.dart';
import 'recipe_feature/data/repositories/recipe_repository.dart';
import 'recipe_feature/domain/use_cases/fetch_recipe.dart';
import 'recipe_feature/domain/use_cases/fetch_recipes.dart';
import 'recipe_feature/domain/use_cases/upload_recipe.dart';
import 'recipe_feature/presentation/blocs/recipe_bloc.dart';
import 'recipe_feature/presentation/screens/recipe_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final client = http.Client();
            final recipeDataSource = RecipeDataSource(client: client);
            final recipeRepository = RecipeRepository(dataSource: recipeDataSource);

            print('Creating RecipeBloc');
            return RecipeBloc(
              fetchRecipes: FetchRecipes(recipeRepository),
              uploadRecipe: UploadRecipe(recipeRepository),
              fetchRecipe: FetchRecipe(recipeRepository),
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Ukla Recipes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RecipeListScreen(),
      ),
    );
  }
}
