import 'package:flutter/material.dart';

/// Shows the About Pantry Chef dialog
void showAboutPantryChefDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('About Pantry Chef'),
      content: const Text(
        'A small demo app that helps you find recipes from ingredients you have.\n\nVersion 1.0.0',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

/// Shows the Help dialog
void showHelpDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('How to use Pantry Chef'),
      content: const Text('''
Tap ingredients to select them. Use "Find Recipes" to view recipes that contain all selected items.\n\nUse the menu (hamburger) to open Settings or About.\nSettings lets you change theme between Light, Dark, or System.
'''),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
