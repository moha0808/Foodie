import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodie/features/recipes/presentation/recipe_provider.dart';
import 'package:foodie/features/recipes/presentation/favorites_provider.dart';
import 'package:foodie/features/shopping_list/presentation/shopping_list_provider.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeDetailProvider(recipeId));

    return Scaffold(
      body: recipeAsync.when(
        data: (recipe) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'recipe-${recipe.id}',
                  child: CachedNetworkImage(
                    imageUrl: recipe.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              actions: [
                Consumer(
                  builder: (context, ref, child) {
                    ref.watch(favoritesProvider);
                    final isFav = ref.read(favoritesProvider.notifier).isFavorite(recipe.id);
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : null,
                      ),
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(recipe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isFav ? 'Removed from favorites' : 'Added to favorites'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO: Implement share
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                recipe.rating.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${recipe.cuisine} • ${recipe.difficulty}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(child: _InfoItem(icon: Icons.timer_outlined, label: 'Prep', value: '${recipe.prepTimeMinutes}m')),
                        Expanded(child: _InfoItem(icon: Icons.outdoor_grill_outlined, label: 'Cook', value: '${recipe.cookTimeMinutes}m')),
                        Expanded(child: _InfoItem(icon: Icons.people_outline, label: 'Serves', value: '${recipe.servings}')),
                        Expanded(child: _InfoItem(icon: Icons.local_fire_department_outlined, label: 'Calories', value: '${recipe.caloriesPerServing}')),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Ingredients',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...recipe.ingredients.map((ingredient) => Consumer(
                      builder: (context, ref, child) {
                        final isInList = ref.watch(shoppingListProvider).contains(ingredient);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            onTap: () {
                              ref.read(shoppingListProvider.notifier).toggleItem(ingredient);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  isInList ? Icons.check_circle : Icons.check_circle_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: TextStyle(
                                      fontSize: 16,
                                      decoration: isInList ? TextDecoration.lineThrough : null,
                                      color: isInList ? Colors.grey : null,
                                    ),
                                  ),
                                ),
                                if (!isInList)
                                  const Icon(Icons.add_shopping_cart, size: 16, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                    const SizedBox(height: 32),
                    const Text(
                      'Instructions',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...recipe.instructions.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              (entry.key + 1).toString(),
                              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
