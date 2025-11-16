import 'package:flutter/material.dart';
import '../models.dart';

class IngredientSelectorScreen extends StatefulWidget {
  final Set<String> selectedIngredients;
  final Function(String) onIngredientToggled;
  final VoidCallback onNavigateToRecipes;
  final VoidCallback? onHelpPressed;

  const IngredientSelectorScreen({
    super.key,
    required this.selectedIngredients,
    required this.onIngredientToggled,
    required this.onNavigateToRecipes,
    this.onHelpPressed,
  });

  @override
  State<IngredientSelectorScreen> createState() =>
      _IngredientSelectorScreenState();
}

class _IngredientSelectorScreenState extends State<IngredientSelectorScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IngredientCategory> _getFilteredCategories() {
    if (_searchQuery.isEmpty) {
      return ingredientCategories;
    }

    return ingredientCategories
        .map((category) {
          final filteredIngredients = category.ingredients
              .where(
                (ingredient) =>
                    ingredient.name.toLowerCase().contains(_searchQuery),
              )
              .toList();
          return IngredientCategory(category.name, filteredIngredients);
        })
        .where((category) => category.ingredients.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('What\'s in your pantry?'),
              floating: true,
              pinned: true,
              toolbarHeight: 80,
              expandedHeight: 120,
              actions: [
                if (widget.onHelpPressed != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.help_outline),
                      onPressed: widget.onHelpPressed,
                      tooltip: 'Help',
                    ),
                  ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
                title: Text(
                  '${widget.selectedIngredients.length} Items Selected',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search or add ingredients...',
                  leading: const Icon(Icons.search),
                  onTap: () {},
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._getFilteredCategories().map((category) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: category.ingredients.map((ingredient) {
                              final isSelected = widget.selectedIngredients
                                  .contains(ingredient.name);
                              return FilterChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                label: Text(ingredient.name),
                                avatar: Icon(ingredient.icon),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  widget.onIngredientToggled(ingredient.name);
                                },
                                selectedColor: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: FilledButton.icon(
              onPressed: widget.selectedIngredients.isEmpty
                  ? null
                  : widget.onNavigateToRecipes,
              icon: const Icon(Icons.search),
              label: const Text('Find Recipes', style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
