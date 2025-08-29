import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:partyu/widgets/category_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    if (_searchController.text.trim().isNotEmpty) {
      context.read<AppProvider>().navigateToSearchResults(
        query: _searchController.text.trim(),
      );
    }
  }

  void _handleCategorySearch(String category) {
    context.read<AppProvider>().navigateToSearchResults(
      category: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Buscar'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 24),

            // Popular Searches
            _buildPopularSearches(),
            const SizedBox(height: 32),

            // Categories
            _buildCategories(),
            const SizedBox(height: 32),

            // Recent Searches
            _buildRecentSearches(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _handleSearch(),
        decoration: InputDecoration(
          hintText: 'Buscar profissionais, serviços...',
          hintStyle: const TextStyle(color: AppTheme.gray400),
          prefixIcon: const Icon(
            LucideIcons.search,
            color: AppTheme.gray400,
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: _handleSearch,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.arrowRight,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPopularSearches() {
    final popularSearches = [
      'Fotógrafos para casamento',
      'Espaços para festa',
      'DJs para evento',
      'Decoração',
      'Buffet',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.trendingUp,
              color: AppTheme.primaryPurple,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Buscas Populares',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularSearches.map((search) {
            return GestureDetector(
              onTap: () {
                context.read<AppProvider>().navigateToSearchResults(query: search);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.gray200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.search,
                      color: AppTheme.gray500,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      search,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.gray700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Espaços', 'icon': LucideIcons.building, 'color': const Color(0xFF3B82F6)},
      {'name': 'Fotógrafos', 'icon': LucideIcons.camera, 'color': const Color(0xFFEC4899)},
      {'name': 'DJs', 'icon': LucideIcons.music, 'color': const Color(0xFF10B981)},
      {'name': 'Decoração', 'icon': LucideIcons.sparkles, 'color': const Color(0xFFF59E0B)},
      {'name': 'Buffets', 'icon': LucideIcons.utensils, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Segurança', 'icon': LucideIcons.shield, 'color': const Color(0xFF06B6D4)},
      {'name': 'Som e Luz', 'icon': LucideIcons.lightbulb, 'color': const Color(0xFFF97316)},
      {'name': 'Outros', 'icon': LucideIcons.moreHorizontal, 'color': const Color(0xFF6B7280)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorias',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              name: category['name'] as String,
              icon: category['icon'] as IconData,
              color: category['color'] as Color,
              onTap: () => _handleCategorySearch(category['name'] as String),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentSearches() {
    final recentSearches = [
      'Fotógrafo para casamento',
      'Espaço para aniversário',
      'DJ para festa',
    ];

    if (recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.clock,
                  color: AppTheme.gray500,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Buscas Recentes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray700,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Clear recent searches
              },
              child: const Text(
                'Limpar',
                style: TextStyle(
                  color: AppTheme.primaryPurple,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: recentSearches.map((search) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: const Icon(
                  LucideIcons.clock,
                  color: AppTheme.gray400,
                  size: 20,
                ),
                title: Text(
                  search,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.gray700,
                  ),
                ),
                trailing: const Icon(
                  LucideIcons.arrowUpRight,
                  color: AppTheme.gray400,
                  size: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.white,
                onTap: () {
                  context.read<AppProvider>().navigateToSearchResults(query: search);
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}