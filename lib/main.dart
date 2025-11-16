// This is a complete, runnable Flutter app demonstrating a Material 3
// recipe book interface focused on ingredient selection.
import 'package:flutter/material.dart';

import 'models.dart';
import 'screens/main_scaffold.dart';

void main() {
  runApp(const PantryChefApp());
}

class PantryChefApp extends StatefulWidget {
  const PantryChefApp({super.key});

  @override
  State<PantryChefApp> createState() => _PantryChefAppState();
}

class _PantryChefAppState extends State<PantryChefApp> {
  ThemeMode _themeMode = ThemeMode.system;
  List<Recipe> _recipes = const [];

  @override
  void initState() {
    super.initState();
    loadRecipesFromAsset()
        .then((list) {
          setState(() => _recipes = list);
        })
        .catchError((_) {
          // If asset load fails, fall back to some inline examples
          setState(() {
            _recipes = const [
              Recipe(
                'Fallback Toast',
                'https://placehold.co/600x400/ccc/000?text=Fallback',
                ['Bread', 'Cheese'],
              ),
            ];
          });
        });
  }

  void _setThemeMode(ThemeMode mode) => setState(() => _themeMode = mode);

  @override
  Widget build(BuildContext context) {
    const Color seedColor = Color(0xFFFFC107);

    return MaterialApp(
      title: 'Pantry Chef',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      home: MainScaffold(
        recipes: _recipes,
        onThemeModeChanged: _setThemeMode,
        currentThemeMode: _themeMode,
      ),
    );
  }
}
