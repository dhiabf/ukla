import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukla/core/widgets/custom_button.dart';
import 'package:ukla/recipe_feature/data/models/step_data.dart';
import 'package:ukla/recipe_feature/presentation/blocs/recipe_bloc.dart';
import 'package:ukla/recipe_feature/presentation/blocs/recipe_event.dart';
import 'package:ukla/recipe_feature/presentation/blocs/recipe_state.dart';
import 'package:ukla/recipe_feature/presentation/screens/recipe_list_screen.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController stepTitleController = TextEditingController();
  final TextEditingController stepInstructionController = TextEditingController();
  final List<StepData> steps = [];
  XFile? selectedVideo;
  VideoPlayerController? _videoPlayerController;
  bool isLoading = false; // Flag to track loading state

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeBloc = BlocProvider.of<RecipeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Add Recipe', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 4,
      ),
      body: BlocListener<RecipeBloc, RecipeState>(
        listener: (context, state) {
          if (state is RecipeLoading) {
            setState(() {
              isLoading = true; // Show loading overlay
            });
          } else if (state is RecipeAdded) {
            setState(() {
              isLoading = false; // Hide loading overlay
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Recipe uploaded successfully!'),
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                recipeBloc.add(FetchRecipesEvent()); // Fetch recipes when returning
                return const RecipeListScreen(); // Return to the list screen
              }),
            );
          } else if (state is RecipeError) {
            setState(() {
              isLoading = false; // Hide loading overlay
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to upload recipe: ${state.failure.message}'),
            ));
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Recipe Title'),
                  const SizedBox(height: 8),
                  _buildTextField(titleController, 'Enter the recipe title'),
                  const SizedBox(height: 20.0),
                  _buildVideoPicker(),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle('Step Title'),
                  const SizedBox(height: 8),
                  _buildTextField(stepTitleController, 'Enter step title'),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle('Step Instruction'),
                  const SizedBox(height: 8),
                  _buildTextField(stepInstructionController, 'Enter step instruction', maxLines: 4),
                  const SizedBox(height: 20.0),
                  TextButton.icon(
                    onPressed: _addStep,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text("Add Step"),
                  ),
                  const SizedBox(height: 20.0),
                  _buildStepList(),
                  const SizedBox(height: 20.0),
                  Center(
                    child: CustomButton(
                      onPressed: _uploadRecipe,
                      title: 'Upload Recipe',
                    ),
                  ),
                ],
              ),
            ),
            // Loading overlay
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Add padding
      ),
    );
  }

  Widget _buildVideoPicker() {
    return GestureDetector(
      onTap: _pickVideo,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (selectedVideo == null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, size: 40, color: Colors.green),
                    SizedBox(height: 8),
                    Text(
                      'Add Video',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              else if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                  ),
                ),
              if (selectedVideo != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _playVideo,
                        icon: Icon(
                          _videoPlayerController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: _deleteVideo,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 8), // Spacing between cards
          child: ListTile(
            title: Text(steps[index].stepTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(steps[index].instructions),
            tileColor: Colors.grey[100],
          ),
        );
      },
    );
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        selectedVideo = video;
        _videoPlayerController = VideoPlayerController.file(File(video.path))
          ..initialize().then((_) {
            setState(() {});
          });
      });
    }
  }

  void _playVideo() {
    if (_videoPlayerController != null) {
      setState(() {
        _videoPlayerController!.value.isPlaying ? _videoPlayerController!.pause() : _videoPlayerController!.play();
      });
    }
  }

  void _deleteVideo() {
    setState(() {
      selectedVideo = null;
      _videoPlayerController?.dispose();
      _videoPlayerController = null;
    });
  }

  void _addStep() {
    if (stepTitleController.text.isNotEmpty && stepInstructionController.text.isNotEmpty) {
      setState(() {
        steps.add(StepData(
          stepTitle: stepTitleController.text,
          instructions: stepInstructionController.text,
        ));
        stepTitleController.clear();
        stepInstructionController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please complete both step title and instructions.'),
      ));
    }
  }

  void _uploadRecipe() async { // Make the function async
    if (selectedVideo != null && titleController.text.isNotEmpty && steps.isNotEmpty) {
      final recipeBloc = BlocProvider.of<RecipeBloc>(context);

      // Await the future to get the actual duration
      final duration = await selectedVideo!.length();
      final durationInSeconds = (duration / 100000).round(); // Convert to seconds and round

      // Check if the duration is less than 30 seconds
      if (durationInSeconds < 30) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Video must be at least 30 seconds long.'),
        ));
        return; // Exit the function if the video is too short
      }

      final recipeData = {
        'title': titleController.text,
        'videoPath': selectedVideo!.path,
        'duration': durationInSeconds, // Use the awaited duration here

        'steps': steps.map((step) => {
          'step_title': step.stepTitle,
          'instructions': step.instructions,
        }).toList(),
      };

      recipeBloc.add(AddRecipeEvent(recipeData, selectedVideo!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please complete all fields and select a video.'),
      ));
    }
  }
}
