import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/services/database_service.dart';
import 'package:partyu/models/venue_model.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:partyu/widgets/venue_card.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final _searchController = TextEditingController();
  List<Venue> _venues = [];
  bool _isLoading = true;
  String _sortBy = 'relevance';
  List<String> _filters = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = context.read<AppProvider>();
      _searchController.text = appProvider.searchQuery;
      _loadResults();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadResults() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appProvider = context.read<AppProvider>();
      final venues = await DatabaseService.instance.searchVenues(
        appProvider.searchQuery.isEmpty ? null : appProvider.searchQuery,
        appProvider.searchCategory.isEmpty ? null : appProvider.searchCategory,
      );

      if (mounted) {
        setState(() {
          _venues = venues;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleSearch() {
    if (_searchController.text.trim().isNotEmpty) {
      context.read<AppProvider>().navigateToSearchResults(
        query: _searchController.text.trim(),
      );
      _loadResults();
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            appProvider.navigateBack();
          },
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: _buildSearchBar(),
          ),

          // Filters and Sort
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildFiltersAndSort(),
          ),

          // Results
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _handleSearch(),
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: const TextStyle(color: AppTheme.gray400),
          prefixIcon: const Icon(
            LucideIcons.search,
            color: AppTheme.gray400,
            size: 20,
          ),
          suffixIcon: IconButton(
            onPressed: _handleSearch,
            icon: const Icon(
              LucideIcons.arrowRight,
              color: AppTheme.primaryPurple,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFiltersAndSort() {
    return Row(
      children: [
        // Results count
        Expanded(
          child: Text(
            '${_venues.length} resultado${_venues.length != 1 ? 's' : ''} encontrado${_venues.length != 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.gray600,
            ),
          ),
        ),

        // Filter button
        OutlinedButton.icon(
          onPressed: _showFilterBottomSheet,
          icon: const Icon(LucideIcons.filter, size: 16),
          label: const Text('Filtros'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.gray700,
            side: const BorderSide(color: AppTheme.gray300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),

        // Sort button
        OutlinedButton.icon(
          onPressed: _showSortBottomSheet,
          icon: const Icon(LucideIcons.arrowUpDown, size: 16),
          label: const Text('Ordenar'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.gray700,
            side: const BorderSide(color: AppTheme.gray300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryPurple,
        ),
      );
    }

    if (_venues.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                LucideIcons.search,
                color: AppTheme.gray400,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros ou buscar por outros termos',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadResults,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _venues.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: VenueCard(
              venue: _venues[index],
              onTap: () {
                context.read<AppProvider>().navigateToVenueProfile(_venues[index].id);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtros',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                    });
                  },
                  child: const Text(
                    'Limpar',
                    style: TextStyle(color: AppTheme.primaryPurple),
                  ),
                ),
              ],
            ),
          ),

          // Filters content
          Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category filter
                  Text(
                    'Categoria',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Espaços', 'Fotógrafos', 'DJs', 'Decoração', 'Buffets'].map((category) {
                      final isSelected = _filters.contains(category);
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _filters.add(category);
                            } else {
                              _filters.remove(category);
                            }
                          });
                        },
                        selectedColor: AppTheme.primaryPurple.withOpacity(0.1),
                        checkmarkColor: AppTheme.primaryPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.primaryPurple : AppTheme.gray700,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Price range
                  Text(
                    'Faixa de Preço',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Até R\$ 500', 'R\$ 500 - R\$ 1.000', 'R\$ 1.000 - R\$ 2.000', 'Acima de R\$ 2.000'].map((price) {
                      final isSelected = _filters.contains(price);
                      return FilterChip(
                        label: Text(price),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _filters.add(price);
                            } else {
                              _filters.remove(price);
                            }
                          });
                        },
                        selectedColor: AppTheme.primaryPurple.withOpacity(0.1),
                        checkmarkColor: AppTheme.primaryPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.primaryPurple : AppTheme.gray700,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _loadResults();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Aplicar Filtros'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Ordenar por',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Sort options
            Column(
              children: [
                'Relevância',
                'Avaliação',
                'Preço (menor para maior)',
                'Preço (maior para menor)',
                'Distância',
              ].map((option) {
                final value = option.toLowerCase().replaceAll(' ', '');
                return ListTile(
                  title: Text(option),
                  trailing: _sortBy == value
                      ? const Icon(LucideIcons.check, color: AppTheme.primaryPurple)
                      : null,
                  onTap: () {
                    setState(() {
                      _sortBy = value;
                    });
                    Navigator.pop(context);
                    _loadResults();
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}