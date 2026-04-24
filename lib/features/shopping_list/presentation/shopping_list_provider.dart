import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final shoppingListBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('shopping_list');
});

class ShoppingListNotifier extends StateNotifier<List<String>> {
  final Box<String> _box;

  ShoppingListNotifier(this._box) : super(_box.values.toList());

  void addItem(String item) {
    if (!_box.values.contains(item)) {
      _box.add(item);
      state = _box.values.toList();
    }
  }

  void removeItem(String item) {
    final key = _box.keys.firstWhere((k) => _box.get(k) == item, orElse: () => null);
    if (key != null) {
      _box.delete(key);
      state = _box.values.toList();
    }
  }

  void toggleItem(String item) {
    if (_box.values.contains(item)) {
      removeItem(item);
    } else {
      addItem(item);
    }
  }

  bool contains(String item) {
    return _box.values.contains(item);
  }
}

final shoppingListProvider = StateNotifierProvider<ShoppingListNotifier, List<String>>((ref) {
  final box = ref.read(shoppingListBoxProvider);
  return ShoppingListNotifier(box);
});
