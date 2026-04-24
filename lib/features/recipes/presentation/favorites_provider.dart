import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodie/features/recipes/data/recipe_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

final favoritesBoxProvider = Provider<Box<Recipe>>((ref) {
  return Hive.box<Recipe>('favorites');
});

class FavoritesNotifier extends StateNotifier<List<Recipe>> {
  final Box<Recipe> _box;

  FavoritesNotifier(this._box) : super(_box.values.toList());

  void toggleFavorite(Recipe recipe) {
    if (_box.containsKey(recipe.id)) {
      _box.delete(recipe.id);
    } else {
      _box.put(recipe.id, recipe);
    }
    state = _box.values.toList();
  }

  bool isFavorite(int id) {
    return _box.containsKey(id);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Recipe>>((ref) {
  final box = ref.read(favoritesBoxProvider);
  return FavoritesNotifier(box);
});
