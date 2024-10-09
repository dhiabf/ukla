import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukla/recipe_feature/presentation/blocs/recipe_bloc.dart';
import 'package:ukla/recipe_feature/presentation/blocs/recipe_event.dart';
import 'package:ukla/recipe_feature/presentation/blocs/recipe_state.dart';
import 'package:ukla/recipe_feature/presentation/screens/recipe_list_screen.dart';
import 'package:video_player/video_player.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final String recipeId;

  const RecipeDetailsScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeBloc = BlocProvider.of<RecipeBloc>(context);
    recipeBloc.add(FetchRecipeDetails(recipeId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Recipe Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                recipeBloc.add(FetchRecipesEvent()); // Fetch recipes when returning
                return const RecipeListScreen(); // Return to the list screen
              }),
            );
          },
        ),
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeDetailsLoaded) {
            final recipe = state.recipe;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Creator ID: ${recipe.creatorId}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: ${recipe.duration} minutes',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Video Player UI
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          children: [
                            VideoPlayer(state.videoController!),
                            // Slider for video progress
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                                    onPressed: () {
                                      if (state.isPlaying) {
                                        recipeBloc.add(PauseVideo());
                                      } else {
                                        recipeBloc.add(PlayVideo());
                                      }
                                    },
                                    iconSize: 32,
                                    color: Colors.teal,
                                  ),
                                  Expanded(
                                    child: Slider(
                                      min: 0.0,
                                      max: state.videoController!.value.duration.inSeconds.toDouble(),
                                      value: state.videoController!.value.position.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        state.videoController!.seekTo(Duration(seconds: value.toInt()));
                                      },
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Steps:',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      itemCount: recipe.steps.length,
                      shrinkWrap: true, // Allow for proper scrolling
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling of inner list
                      itemBuilder: (context, index) {
                        final step = recipe.steps[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Step ${step.stepNumber}: ${step.title}', // Display the step title
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  step.instructions, // Display the instructions for the step
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            );
          } else if (state is RecipeError) {
            return Center(child: Text(state.failure.message));
          } else {
            return const Center(child: Text("Something went wrong!"));
          }
        },
      ),
    );
  }
}
