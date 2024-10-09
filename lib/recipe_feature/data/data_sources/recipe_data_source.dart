import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:ukla/core/constants/api_constants.dart';
import 'package:ukla/recipe_feature/domain/entities/fetched_recipe.dart';

import '../models/recipe_model.dart';

class RecipeDataSource {
  final http.Client client;

  RecipeDataSource({required this.client});

  Future<List<RecipeModel>> fetchRecipes() async {
    try {
      final response = await client.get(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.getRecipesEndpoint));

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> recipesJson = jsonResponse['recipes'];

        return recipesJson
            .map((recipe) => RecipeModel.fromJson(recipe))
            .toList();
      } else {
        if (kDebugMode) {
          print('Error fetching recipes: ${response.reasonPhrase}');
        }
        throw Exception('Failed to load recipes: ${response.reasonPhrase}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception caught: $error');
      }
      throw Exception('Failed to load recipes: $error');
    }
  }

  Future<FetchedRecipe> fetchRecipeById(String id) async {
    try {
      final response = await client.get(Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.getRecipesEndpoint}/$id"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(' fetching recipe: ${response.body}');

        return FetchedRecipe.fromJson(jsonResponse);

      } else {
        if (kDebugMode) {
          print('Error fetching recipe: ${response.reasonPhrase}');
        }
        throw Exception('Failed to load recipe: ${response.reasonPhrase}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception caught: $error');
      }
      throw Exception('Failed to load recipe: $error');
    }
  }

  Future<void> uploadRecipe(Map<String, dynamic> recipeData) async {
    try {
      String videoPath = recipeData['videoPath'];
      String title = recipeData['title'];
      List<dynamic> steps = recipeData['steps'];
      if (kDebugMode) {
        print('Received recipe data:');
        print('Video Path: $videoPath');
        print('Title: $title');
        print('Steps: $steps');
      }

      if (videoPath.isEmpty || title.isEmpty || steps.isEmpty) {
        throw Exception('Video path, title, and steps are required');
      }

      String creatorId = Random().nextInt(100000).toString();
      // Ensure that duration is converted to a string
      String duration = recipeData['duration'].toString(); // Convert to String

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.baseUrl + ApiConstants.uploadRecipeEndpoint),
      );

      if (kDebugMode) {
        print('Request URL: ${request.url}');
      }

      request.fields['title'] = title;
      request.fields['creator_id'] = creatorId;
      request.fields['duration'] = duration; // Use the string duration
      request.fields['steps'] = json.encode(steps.map((step) {
        return {
          'step_title': step['step_title'],
          'instructions': step['instructions']
        };
      }).toList());

      if (kDebugMode) {
        print('Formatted Steps: ${request.fields['steps']}');
      }

      var videoFile = await http.MultipartFile.fromPath(
        'video',
        videoPath,
        filename: basename(videoPath),
      );

      request.files.add(videoFile);

      if (kDebugMode) {
        print('Video file added: ${videoFile.filename}, Path: $videoPath');
      }

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('Upload response status: ${response.statusCode}');
        print('Upload response body: ${response.body}');
      }

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('Error uploading recipe: ${response.reasonPhrase}');
        }
        throw Exception('Failed to upload recipe: ${response.reasonPhrase}');
      } else {
        if (kDebugMode) {
          print('Recipe uploaded successfully');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Exception caught during upload: $error');
      }
      throw Exception('Failed to upload recipe: $error');
    }
  }
}
