import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/auth_provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/services/database_service.dart';
import 'package:partyu/models/venue_model.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:partyu/widgets/venue_card.dart';
import 'package:partyu/widgets/category_card.dart';
import 'package:partyu/widgets/guide_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Venue> _venues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    try {
      final venues = await DatabaseService.instance.getVenues();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadVenues,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              // Categories
              SliverToBoxAdapter(
                child: _buildCategoriesSection(),
              ),

              // Guide Section
              SliverToBoxAdapter(
                child: _buildGuideSection(),
              ),

              // Recommendations
              SliverToBoxAdapter(
                child: _buildRecommendationsSection(),
              ),

              // Venues List
              _isLoading
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= _venues.length) return null;
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
                          childCount: _venues.length,
                        ),
                      ),
                    ),

              // Bottom Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.heart,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Party',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.gray900,
                              ),
                            ),
                            Text(
                              'U',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Olá, ${authProvider.user?.name ?? 'Usuário'}! 👋',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          context.read<AppProvider>().navigateToSearch();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Icon(
                          LucideIcons.search,
                          color: AppTheme.gray600,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location
              Row(
                children: [
                  const Icon(
                    LucideIcons.mapPin,
                    color: AppTheme.primaryPurple,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'São Paulo, SP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.gray500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'name': 'Espaços', 'icon': LucideIcons.building, 'color': const Color(0xFF3B82F6)},
      {'name': 'Fotógrafos', 'icon': LucideIcons.camera, 'color': const Color(0xFFEC4899)},
      {'name': 'DJs', 'icon': LucideIcons.music, 'color': const Color(0xFF10B981)},
      {'name': 'Decoração', 'icon': LucideIcons.sparkles, 'color': const Color(0xFFF59E0B)},
      {'name': 'Buffets', 'icon': LucideIcons.utensils, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Outros', 'icon': LucideIcons.moreHorizontal, 'color': const Color(0xFF6B7280)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorias',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppProvider>().navigateToSearch();
                },
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CategoryCard(
                  name: category['name'] as String,
                  icon: category['icon'] as IconData,
                  color: category['color'] as Color,
                  onTap: () {
                    context.read<AppProvider>().navigateToSearchResults(
                      category: category['name'] as String,
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildGuideSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Planejamento Inteligente',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GuideCard(
            onTap: () {
              context.read<AppProvider>().navigateToScreen(AppScreen.eventGuide);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recomendados para você',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}