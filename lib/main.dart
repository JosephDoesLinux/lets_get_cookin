// This is a complete, runnable Flutter app demonstrating a Material 3
// recipe book interface focused on ingredient selection.
import 'package:flutter/material.dart';

void main() {
  runApp(const PantryChefApp());
}

// --- 1. DATA MODELS ---

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
}

// Sample Data
const List<Ingredient> allIngredients = [
  Ingredient('Chicken', Icons.dining_outlined),
  Ingredient('Pasta', Icons.ramen_dining_outlined),
  Ingredient('Tomato', Icons.local_florist_outlined),
  Ingredient('Egg', Icons.egg_alt_outlined),
  Ingredient('Onion', Icons.fastfood_outlined),
  Ingredient('Garlic', Icons.grass_outlined),
  Ingredient('Rice', Icons.rice_bowl_outlined),
  Ingredient('Broccoli', Icons.local_pizza_outlined),
  Ingredient('Cheese', Icons.bakery_dining_outlined),
  Ingredient('Bread', Icons.lunch_dining_outlined),
];

const List<Recipe> sampleRecipes = [
  Recipe('Spicy Garlic Chicken Stir Fry', 'https://placehold.co/600x400/80C0B0/ffffff?text=Chicken+Stir+Fry', ['Chicken', 'Garlic', 'Broccoli', 'Rice']),
  Recipe('Creamy Tomato Pasta', 'https://placehold.co/600x400/F47C7C/ffffff?text=Tomato+Pasta', ['Pasta', 'Tomato', 'Cheese', 'Onion']),
  Recipe('Egg and Cheese Toast', 'https://placehold.co/600x400/FFF8B7/000000?text=Breakfast+Toast', ['Egg', 'Cheese', 'Bread']),
  Recipe('Simple Roasted Broccoli', 'https://placehold.co/600x400/90EE90/000000?text=Roasted+Veg', ['Broccoli', 'Garlic']),
];

// --- 2. THEME SETUP (Material You / Pixel Style) ---

class PantryChefApp extends StatelessWidget {
  const PantryChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    // A bright, appetizing color for the Material You seed.
    // This generates the full tonal M3 palette (primary, secondary, surface, etc.)
    // which is the core of the Material You aesthetic.
    const Color seedColor = Color(0xFFFFC107); // A vibrant Amber, similar to your inspo images

    return MaterialApp(
      title: 'Pantry Chef',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        // Global visual density and rounded corners
        cardTheme: CardThemeData(
          elevation: 0, // M3 favors tonal surfaces over deep shadows
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

// --- 3. MAIN SCAFFOLD & NAVIGATION ---

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  // Track selected ingredients globally
  final Set<String> _selectedIngredients = {};

  void _onIngredientToggled(String ingredientName) {
    setState(() {
      if (_selectedIngredients.contains(ingredientName)) {
        _selectedIngredients.remove(ingredientName);
      } else {
        _selectedIngredients.add(ingredientName);
      }
    });
  }

  // Screens to be displayed in the BottomNavigationBar
  late final List<Widget> _widgetOptions = <Widget>[
    IngredientSelectorScreen(
      selectedIngredients: _selectedIngredients,
      onIngredientToggled: _onIngredientToggled,
    ),
    RecipeResultsScreen(
      selectedIngredients: _selectedIngredients,
    ),
    const Center(child: Text('Profile Screen - Coming Soon', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the generated color scheme for M3 styling
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // The body updates based on the selected index
      body: _widgetOptions.elementAt(_selectedIndex),
      
      // Material 3 Navigation Bar (replaces BottomNavigationBar)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        // The M3 tonal design uses the container colors for background
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
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// --- 4. INGREDIENT SELECTION SCREEN (The Main Feature) ---

class IngredientSelectorScreen extends StatelessWidget {
  final Set<String> selectedIngredients;
  final Function(String) onIngredientToggled;

  const IngredientSelectorScreen({
    super.key,
    required this.selectedIngredients,
    required this.onIngredientToggled,
  });

  @override
  Widget build(BuildContext context) {
    // M3 often uses a large, prominent title
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('What\'s in your pantry?'),
          floating: true,
          pinned: true,
          toolbarHeight: 80,
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: const EdgeInsets.only(bottom: 16),
            title: Text(
              '${selectedIngredients.length} Items Selected',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Use a SliverToBoxAdapter for non-scrollable content like the SearchBar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              hintText: 'Search or add ingredients...',
              leading: const Icon(Icons.search),
              onTap: () {
                // In a real app, this would open a search delegate
              },
            ),
          ),
        ),
        
        // This is the main ingredient selection area
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Common Ingredients',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: allIngredients.map((ingredient) {
                    final isSelected = selectedIngredients.contains(ingredient.name);
                    return FilterChip(
                      // M3 uses rounded corners extensively
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      label: Text(ingredient.name),
                      avatar: Icon(ingredient.icon),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        onIngredientToggled(ingredient.name);
                      },
                      // M3 tonal colors for the selected state
                      selectedColor: Theme.of(context).colorScheme.secondaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                // A CTA button to find recipes
                Center(
                  child: FilledButton.icon(
                    onPressed: selectedIngredients.isEmpty ? null : () {
                      // Navigate to the Recipes screen
                      DefaultTabController.of(context)?.animateTo(1); 
                      
                      // In our simple demo, we simulate a tap on the Recipes tab
                      // In MainScaffold, we would need to manually update the index if not using a TabController
                      // For this example, we'll just print to console for simplicity
                      print('Finding recipes with: ${selectedIngredients.join(', ')}');
                      
                      // To make the demo work smoothly, let's navigate the bottom bar manually:
                      (context.findAncestorStateOfType<_MainScaffoldState>() as _MainScaffoldState)._onItemTapped(1);
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Find Recipes', style: TextStyle(fontSize: 16)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- 5. RECIPE RESULTS SCREEN (Grid Layout) ---

class RecipeResultsScreen extends StatelessWidget {
  final Set<String> selectedIngredients;

  const RecipeResultsScreen({
    super.key,
    required this.selectedIngredients,
  });

  // Simple filtering logic
  List<Recipe> getFilteredRecipes() {
    if (selectedIngredients.isEmpty) return sampleRecipes; // Show all if none selected

    return sampleRecipes.where((recipe) {
      // Check if ALL selected ingredients are in the recipe
      return selectedIngredients.every((ingredient) => recipe.ingredients.contains(ingredient));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = getFilteredRecipes();
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Recipes'),
          floating: true,
          pinned: true,
          toolbarHeight: 80,
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: const EdgeInsets.only(bottom: 16),
            title: Text(
              selectedIngredients.isEmpty
                  ? 'Showing All Recipes'
                  : 'Based on: ${selectedIngredients.join(', ')}',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        
        SliverPadding(
          padding: const EdgeInsets.all(12.0),
          sliver: filteredRecipes.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No recipes found for your selected ingredients.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 0.7, // Card height control
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return RecipeCard(recipe: filteredRecipes[index]);
                    },
                    childCount: filteredRecipes.length,
                  ),
                ),
        ),
      ],
    );
  }
}

// --- 6. INDIVIDUAL RECIPE CARD (Inspired by the images) ---

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // M3 Card with subtle tonal color (surfaceContainerLow)
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias, // Ensures the image respects the card's rounded corners
      child: InkWell(
        onTap: () {
          // Navigate to the Recipe Detail Screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tapped on ${recipe.title}')),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image area, similar to the inspo image grid
            Expanded(
              flex: 3,
              child: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
            // Text area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ingredients: ${recipe.ingredients.length}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    // Save button / quick action (similar to the bookmark in the image)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.bookmark_border,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}