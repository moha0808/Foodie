import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodie/features/recipes/data/recipe_model.dart';
import 'package:foodie/features/recipes/data/recipe_repository.dart';

final recipesProvider = FutureProvider.autoDispose<List<Recipe>>((ref) async {
  final repository = ref.read(recipeRepositoryProvider);
  final response = await repository.getRecipes(limit: 50);
  return response.recipes;
});

final recipeDetailProvider = FutureProvider.family.autoDispose<Recipe, int>((ref, id) async {
  final repository = ref.read(recipeRepositoryProvider);
  return await repository.getRecipeById(id);
});

final searchRecipesProvider = FutureProvider.family.autoDispose<List<Recipe>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.read(recipeRepositoryProvider);
  final response = await repository.searchRecipes(query);
  return response.recipes;
});

final categoriesProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final repository = ref.read(recipeRepositoryProvider);
  return await repository.getCategories();
});

final categoryRecipesProvider = FutureProvider.family.autoDispose<List<Recipe>, String>((ref, category) async {
  final repository = ref.read(recipeRepositoryProvider);
  final response = await repository.getRecipesByCategory(category);
  return response.recipes;
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');
