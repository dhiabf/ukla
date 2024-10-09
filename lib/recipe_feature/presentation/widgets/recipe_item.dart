import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ukla/recipe_feature/domain/entities/recipe_entity.dart';
import '../screens/recipe_details_screen.dart';
import 'package:shimmer/shimmer.dart';

class RecipeItem extends StatelessWidget {
  final RecipeEntity recipe;

  const RecipeItem({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Column(
        children: [
          // Thumbnail with Play Button Overlay
          Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder<String?>(
                future: _generateThumbnail(recipe.videoUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerLoader();
                  } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                    return _buildErrorPlaceholder();
                  } else {
                    return Image.file(
                      File(snapshot.data!),
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    );
                  }
                },
              ),

            ],
          ),

          const SizedBox(height: 12),

          // Recipe Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              recipe.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          // Recipe Duration
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Duration: ${recipe.duration} seconds',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Open Recipe Button
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                primary: Colors.teal,
                elevation: 3,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsScreen(
                      recipeId: recipe.recipeId,
                    ),
                  ),
                );
              },
              child: const Text(
                'Open Recipe',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 8),
          const Text(
            'Error generating thumbnail',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Future<String?> _generateThumbnail(String videoUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 75,
      );

      return thumbnailPath;
    } catch (e) {
      print('Error generating thumbnail for video: $videoUrl - $e');
      return null; // Return null on error
    }
  }
}
