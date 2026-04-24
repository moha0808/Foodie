import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Recipe {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<String> ingredients;
  @HiveField(3)
  final List<String> instructions;
  @HiveField(4)
  final int prepTimeMinutes;
  @HiveField(5)
  final int cookTimeMinutes;
  @HiveField(6)
  final int servings;
  @HiveField(7)
  final String difficulty;
  @HiveField(8)
  final String cuisine;
  @HiveField(9)
  final int caloriesPerServing;
  @HiveField(10)
  final List<String> tags;
  @HiveField(11)
  final String image;
  @HiveField(12)
  final double rating;
  @HiveField(13)
  final int reviewCount;
  @HiveField(14)
  final List<String> mealType;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.tags,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.mealType,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}

@JsonSerializable()
class RecipeResponse {
  final List<Recipe> recipes;
  final int total;
  final int skip;
  final int limit;

  RecipeResponse({
    required this.recipes,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) => _$RecipeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeResponseToJson(this);
}
