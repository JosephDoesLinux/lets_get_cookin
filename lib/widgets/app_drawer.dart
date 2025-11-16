import 'package:flutter/material.dart';

// --- Placeholder utilities for the sake of making this file runnable ---

// Placeholder for the external file 'utils/app_dialogs.dart'
void showAboutPantryChefDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('About Pantry Chef'),
        content: const Text('A Material 3 recipe finder app.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

// Placeholder for the external file 'utils/settings_bottom_sheet.dart'
void showSettingsBottomSheet({
  required BuildContext context,
  required ThemeMode currentThemeMode,
  required void Function(ThemeMode) onThemeModeChanged,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            ListTile(
              title: const Text('Theme Mode'),
              trailing: DropdownButton<ThemeMode>(
                value: currentThemeMode,
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                ],
                onChanged: (ThemeMode? newValue) {
                  if (newValue != null) {
                    onThemeModeChanged(newValue);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
// --------------------------------------------------------------------


/// Custom drawer widget with credits, about, and settings
class AppDrawer extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final void Function(ThemeMode) onThemeModeChanged;

  const AppDrawer({
    super.key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- FIX IS HERE: Custom Drawer Header for Material 3 look ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
              child: Text(
                'Pantry Chef',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      // Using the primary color for a vibrant M3 look
                      color: colorScheme.primary,
                    ),
              ),
            ),
            // --- END FIX ---
            
            // The rest of the original content goes into a flexible area
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero, // Remove ListView default padding
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Credits',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '52330567 Joseph Abou Antoun\n52331136 Zeina Al Homsi',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening GitHub repository...'),
                              ),
                            );
                          },
                          child: Text(
                            'github.com/JosephDoesLinux/lets_get_cookin',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About'),
                    onTap: () {
                      Navigator.of(context).pop();
                      showAboutPantryChefDialog(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.of(context).pop();
                      showSettingsBottomSheet(
                        context: context,
                        currentThemeMode: currentThemeMode,
                        onThemeModeChanged: onThemeModeChanged,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}