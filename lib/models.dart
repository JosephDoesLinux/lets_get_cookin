import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class Ingredient {
  final String name;
  final IconData icon;

  const Ingredient(this.name, this.icon);
}

class Recipe {
  final String title;
  final String imageUrl;
  final List<String> ingredients;

  const Recipe(this.title, this.imageUrl, this.ingredients);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      json['title'] as String,
      json['imageUrl'] as String,
      List<String>.from(json['ingredients'] as List<dynamic>),
    );
  }
}

// Helper to load recipes from assets/recipes.json
Future<List<Recipe>> loadRecipesFromAsset() async {
  final raw = await rootBundle.loadString('assets/recipes.json');
  final data = json.decode(raw) as List<dynamic>;
  return data.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
}

// Categorized ingredients for better organization
class IngredientCategory {
  final String name;
  final List<Ingredient> ingredients;

  const IngredientCategory(this.name, this.ingredients);
}

const List<IngredientCategory> ingredientCategories = [
  IngredientCategory('Proteins', [
    Ingredient('Chicken', Icons.dining_outlined),
    Ingredient('Lamb', Icons.restaurant_menu_outlined),
    Ingredient('Beef', Icons.fastfood_outlined),
    Ingredient('Fish', Icons.set_meal_outlined),
    Ingredient('Egg', Icons.egg_alt_outlined),
  ]),
  IngredientCategory('Grains & Carbs', [
    Ingredient('Rice', Icons.rice_bowl_outlined),
    Ingredient('Pasta', Icons.ramen_dining_outlined),
    Ingredient('Bread', Icons.lunch_dining_outlined),
    Ingredient('Bulgur', Icons.grain_outlined),
    Ingredient('Hummus', Icons.bakery_dining_outlined),
  ]),
  IngredientCategory('Vegetables', [
    Ingredient('Tomato', Icons.local_florist_outlined),
    Ingredient('Onion', Icons.grass_outlined),
    Ingredient('Garlic', Icons.grass_outlined),
    Ingredient('Broccoli', Icons.local_pizza_outlined),
    Ingredient('Eggplant', Icons.brightness_5_outlined),
    Ingredient('Zucchini', Icons.nature_outlined),
    Ingredient('Cucumber', Icons.water_outlined),
    Ingredient('Bell Pepper', Icons.emoji_nature_outlined),
    Ingredient('Parsley', Icons.eco_outlined),
  ]),
  IngredientCategory('Dairy & Condiments', [
    Ingredient('Cheese', Icons.local_pizza_outlined),
    Ingredient('Yogurt', Icons.blender_outlined),
    Ingredient('Olive Oil', Icons.water_drop_outlined),
    Ingredient('Tahini', Icons.grain_outlined),
    Ingredient('Lemon', Icons.brightness_5_outlined),
  ]),
  IngredientCategory('Spices & Seasonings', [
    Ingredient('Cumin', Icons.brightness_6_outlined),
    Ingredient('Sumac', Icons.auto_awesome_outlined),
    Ingredient('Paprika', Icons.palette_outlined),
    Ingredient('Mint', Icons.eco_outlined),
  ]),
];

// Flattened list for backward compatibility
List<Ingredient> get allIngredients {
  return ingredientCategories
      .expand((category) => category.ingredients)
      .toList();
}
