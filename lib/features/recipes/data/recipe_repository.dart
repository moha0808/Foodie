import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodie/core/network/api_service.dart';
import 'package:foodie/features/recipes/data/recipe_model.dart';

class RecipeRepository {
  final ApiService _apiService;

  RecipeRepository(this._apiService);

  Future<RecipeResponse> getRecipes({int limit = 10, int skip = 0}) async {
    final response = await _apiService.get('/recipes', queryParameters: {
      'limit': limit,
      'skip': skip,
    });
    return RecipeResponse.fromJson(response.data);
  }

  Future<Recipe> getRecipeById(int id) async {
    final response = await _apiService.get('/recipes/$id');
    return Recipe.fromJson(response.data);
  }

  Future<RecipeResponse> searchRecipes(String query) async {
    final response = await _apiService.get('/recipes/search', queryParameters: {
      'q': query,
    });
    return RecipeResponse.fromJson(response.data);
  }

  Future<List<String>> getCategories() async {
    final response = await _apiService.get('/recipes/tags');
    return List<String>.from(response.data);
  }

  Future<RecipeResponse> getRecipesByCategory(String category) async {
    final response = await _apiService.get('/recipes/tag/$category');
    return RecipeResponse.fromJson(response.data);
  }
}

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return RecipeRepository(ref.read(apiServiceProvider));
});
