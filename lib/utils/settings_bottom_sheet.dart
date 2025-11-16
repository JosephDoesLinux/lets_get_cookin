import 'package:flutter/material.dart';

/// Shows the Theme Settings bottom sheet
void showSettingsBottomSheet({
  required BuildContext context,
  required ThemeMode currentThemeMode,
  required void Function(ThemeMode) onThemeModeChanged,
}) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Light'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: currentThemeMode,
                onChanged: (v) {
                  if (v != null) onThemeModeChanged(v);
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Dark'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: currentThemeMode,
                onChanged: (v) {
                  if (v != null) onThemeModeChanged(v);
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Follow System'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: currentThemeMode,
                onChanged: (v) {
                  if (v != null) onThemeModeChanged(v);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
