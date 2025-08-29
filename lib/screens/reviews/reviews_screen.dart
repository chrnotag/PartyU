import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/services/database_service.dart';
import 'package:partyu/models/review_model.dart';
import 'package:partyu/utils/app_theme.dart';
import 'package:intl/intl.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Review> _reviews = [];
  bool _isLoading = true;
  String _sortBy = 'recent';

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appProvider = context.read<AppProvider>();
      final reviews = await DatabaseService.instance.getVenueReviews(appProvider.selectedVenueId);
      
      if (mounted) {
        setState(() {
          _reviews = reviews;
          _isLoading = false;
        });
        _sortReviews();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _sortReviews() {
    setState(() {
      switch (_sortBy) {
        case 'recent':
          _reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'rating_high':
          _reviews.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'rating_low':
          _reviews.sort((a, b) => a.rating.compareTo(b.rating));
          break;
        // case 'helpful':
        //   _reviews.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
        //   break;
      }
    });
  }

  double get _averageRating {
    if (_reviews.isEmpty) return 0.0;
    return _reviews.fold(0.0, (sum, review) => sum + review.rating) / _reviews.length;
  }

  Map<int, int> get _ratingDistribution {
    final distribution = <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final review in _reviews) {
      distribution[review.rating] = (distribution[review.rating] ?? 0) + 1;
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Avaliações'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            appProvider.navigateBack();
          },
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
              _sortReviews();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'recent',
                child: Text('Mais recentes'),
              ),
              const PopupMenuItem(
                value: 'rating_high',
                child: Text('Maior avaliação'),
              ),
              const PopupMenuItem(
                value: 'rating_low',
                child: Text('Menor avaliação'),
              ),
              const PopupMenuItem(
                value: 'helpful',
                child: Text('Mais úteis'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading ? _buildLoading() : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primaryPurple,
      ),
    );
  }

  Widget _buildContent() {
    if (_reviews.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadReviews,
      child: CustomScrollView(
        slivers: [
          // Summary
          SliverToBoxAdapter(
            child: _buildSummary(),
          ),

          // Rating Distribution
          SliverToBoxAdapter(
            child: _buildRatingDistribution(),
          ),

          // Reviews List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildReviewCard(_reviews[index]),
                ),
                childCount: _reviews.length,
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
                LucideIcons.star,
                color: AppTheme.gray400,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma avaliação ainda',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.gray900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Seja o primeiro a avaliar este profissional',
              style: TextStyle(
                color: AppTheme.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          // Rating display
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      LucideIcons.star,
                      size: 12,
                      color: index < _averageRating.round()
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Avaliação Geral',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Baseado em ${_reviews.length} avaliação${_reviews.length != 1 ? 'ões' : ''}',
                  style: const TextStyle(
                    color: AppTheme.gray600,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Quick stats
                Row(
                  children: [
                    _buildQuickStat('Excelente', _ratingDistribution[5]!, Colors.green),
                    const SizedBox(width: 12),
                    _buildQuickStat('Bom', _ratingDistribution[4]!, Colors.blue),
                    const SizedBox(width: 12),
                    _buildQuickStat('Regular', _ratingDistribution[3]! + _ratingDistribution[2]! + _ratingDistribution[1]!, Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution() {
    final maxCount = _ratingDistribution.values.fold(0, (max, count) => count > max ? count : max);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribuição das Avaliações',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: [5, 4, 3, 2, 1].map((rating) {
              final count = _ratingDistribution[rating]!;
              final percentage = maxCount > 0 ? count / maxCount : 0.0;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    // Stars
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          LucideIcons.star,
                          size: 14,
                          color: index < rating
                              ? const Color(0xFFFACC15) // yellow-400
                              : AppTheme.gray300,
                        );
                      }),
                    ),
                    const SizedBox(width: 12),
                    
                    // Progress bar
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.gray200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Count
                    SizedBox(
                      width: 24,
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.gray700,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    final formattedDate = DateFormat('d MMM yyyy', 'pt_BR').format(review.createdAt);

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRatingColor(review.rating).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.star,
                      size: 14,
                      color: _getRatingColor(review.rating),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _getRatingColor(review.rating),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Comment
          if (review.comment?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Text(
              review.comment!,
              style: const TextStyle(
                color: AppTheme.gray700,
                height: 1.5,
              ),
            ),
          ],
          
          // Photos
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.gray200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        review.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            LucideIcons.image,
                            color: AppTheme.gray400,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          
          // Actions
          const SizedBox(height: 16),
          Row(
            children: [
              // Helpful button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Toggle helpful
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.gray300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.thumbsUp,
                          size: 14,
                          color: AppTheme.gray600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Útil (${review.likes})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // if (review.service?.isNotEmpty == true) ...[
              //   const SizedBox(width: 12),
              //   Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //     decoration: BoxDecoration(
              //       color: AppTheme.gray100,
              //       borderRadius: BorderRadius.circular(6),
              //     ),
              //     child: Text(
              //       review.service!,
              //       style: const TextStyle(
              //         fontSize: 10,
              //         color: AppTheme.gray600,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.red.shade300;
      case 1:
        return Colors.red;
      default:
        return AppTheme.gray500;
    }
  }
}