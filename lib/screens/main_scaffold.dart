import 'package:flutter/material.dart';

import '../models.dart';
import '../screens/bookmarks_screen.dart';
import '../screens/ingredient_selector.dart';
import '../screens/recipe_results.dart';
import '../utils/app_dialogs.dart';
import '../widgets/app_drawer.dart';

/// Main scaffold widget that manages the navigation and state
class MainScaffold extends StatefulWidget {
  final List<Recipe> recipes;
  final void Function(ThemeMode) onThemeModeChanged;
  final ThemeMode currentThemeMode;

  const MainScaffold({
    super.key,
    required this.recipes,
    required this.onThemeModeChanged,
    required this.currentThemeMode,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  final Set<String> _selectedIngredients = {};
  final Set<String> _bookmarkedRecipeTitles = {};

  void _onIngredientToggled(String ingredientName) {
    setState(() {
      if (_selectedIngredients.contains(ingredientName))
        _selectedIngredients.remove(ingredientName);
      else
        _selectedIngredients.add(ingredientName);
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _toggleBookmark(String recipeTitle) {
    setState(() {
      if (_bookmarkedRecipeTitles.contains(recipeTitle)) {
        _bookmarkedRecipeTitles.remove(recipeTitle);
      } else {
        _bookmarkedRecipeTitles.add(recipeTitle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final widgetOptions = <Widget>[
      IngredientSelectorScreen(
        selectedIngredients: _selectedIngredients,
        onIngredientToggled: _onIngredientToggled,
        onNavigateToRecipes: () => _onItemTapped(1),
        onHelpPressed: () => showHelpDialog(context),
      ),
      RecipeResultsScreen(
        selectedIngredients: _selectedIngredients,
        loadedRecipes: widget.recipes,
        bookmarkedRecipeTitles: _bookmarkedRecipeTitles,
        onToggleBookmark: _toggleBookmark,
        onHelpPressed: () => showHelpDialog(context),
      ),
      BookmarksScreen(
        loadedRecipes: widget.recipes,
        bookmarkedRecipeTitles: _bookmarkedRecipeTitles,
        onToggleBookmark: _toggleBookmark,
        onHelpPressed: () => showHelpDialog(context),
      ),
    ];

    return Scaffold(
      drawer: AppDrawer(
        currentThemeMode: widget.currentThemeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: colorScheme.surfaceContainerHigh,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen),
            label: 'Pantry',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
