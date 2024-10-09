import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukla/recipe_feature/presentation/screens/add_recipe_screen.dart';
import '../blocs/recipe_bloc.dart';
import '../blocs/recipe_event.dart';
import '../blocs/recipe_state.dart';
import '../widgets/recipe_item.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RecipeBloc>(context).add(FetchRecipesEvent());

    return Scaffold(
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeLoaded) {
            return ListView.builder(
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                return RecipeItem(recipe: state.recipes[index]);
              },
            );
          } else if (state is RecipeError) {
            return Center(child: Text('Error: ${state.failure.message}'));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipeScreen()),
          );
        },
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),

    );
  }
}
