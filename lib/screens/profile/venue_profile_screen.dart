import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:partyu/providers/app_provider.dart';
import 'package:partyu/services/database_service.dart';
import 'package:partyu/models/venue_model.dart';
import 'package:partyu/models/review_model.dart';
import 'package:partyu/utils/app_theme.dart';

class VenueProfileScreen extends StatefulWidget {
  const VenueProfileScreen({super.key});

  @override
  State<VenueProfileScreen> createState() => _VenueProfileScreenState();
}

class _VenueProfileScreenState extends State<VenueProfileScreen> {
  Venue? _venue;
  List<Review> _reviews = [];
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVenueData();
    });
  }

  Future<void> _loadVenueData() async {
    final appProvider = context.read<AppProvider>();
    try {
      final venue = await DatabaseService.instance.getVenueById(appProvider.selectedVenueId);
      final reviews = await DatabaseService.instance.getVenueReviews(appProvider.selectedVenueId);
      
      if (mounted) {
        setState(() {
          _venue = venue;
          _reviews = reviews;
          _isLoading = false;
        });
        
        if (venue != null) {
          appProvider.setVenueName(venue.name);
        }
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryPurple,
          ),
        ),
      );
    }

    if (_venue == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.read<AppProvider>().navigateBack();
            },
            icon: const Icon(LucideIcons.arrowLeft),
          ),
        ),
        body: const Center(
          child: Text('Profissional não encontrado'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image Header
          _buildImageHeader(),

          // Venue Info
          SliverToBoxAdapter(
            child: _buildVenueInfo(),
          ),

          // Action Buttons
          SliverToBoxAdapter(
            child: _buildActionButtons(),
          ),

          // Services
          SliverToBoxAdapter(
            child: _buildServices(),
          ),

          // About
          SliverToBoxAdapter(
            child: _buildAbout(),
          ),

          // Reviews
          SliverToBoxAdapter(
            child: _buildReviews(),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildImageHeader() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () {
            context.read<AppProvider>().navigateBack();
          },
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            icon: Icon(
              _isFavorite ? LucideIcons.heart : LucideIcons.heart,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              // Share functionality
            },
            icon: const Icon(LucideIcons.share, color: Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _venue!.images.isNotEmpty
            ? PageView.builder(
                itemCount: _venue!.images.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: _venue!.images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.gray200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.gray200,
                      child: const Icon(
                        LucideIcons.image,
                        color: AppTheme.gray400,
                        size: 64,
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: AppTheme.gray200,
                child: const Icon(
                  LucideIcons.image,
                  color: AppTheme.gray400,
                  size: 64,
                ),
              ),
      ),
    );
  }

  Widget _buildVenueInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Category
          Row(
            children: [
              Expanded(
                child: Text(
                  _venue!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gray900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _venue!.category,
                  style: const TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rating and Reviews
          Row(
            children: [
              const Icon(
                LucideIcons.star,
                color: Color(0xFFFACC15), // yellow-400
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                _venue!.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${_reviews.length} avaliações)',
                style: const TextStyle(
                  color: AppTheme.gray600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Location
          if (_venue!.address != null) ...[
            Row(
              children: [
                const Icon(
                  LucideIcons.mapPin,
                  color: AppTheme.gray400,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _venue!.address!,
                    style: const TextStyle(
                      color: AppTheme.gray600,
                    ),
                  ),
                ),
                if (_venue!.distance != null) ...[
                  Text(
                    _venue!.distance!,
                    style: const TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Price
          if (_venue!.price != null) ...[
            Row(
              children: [
                const Text(
                  'A partir de ',
                  style: TextStyle(
                    color: AppTheme.gray600,
                  ),
                ),
                Text(
                  _venue!.price!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                if (_venue!.period != null) ...[
                  Text(
                    '/${_venue!.period}',
                    style: const TextStyle(
                      color: AppTheme.gray600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<AppProvider>().navigateToChat(_venue!.name);
              },
              icon: const Icon(LucideIcons.messageCircle),
              label: const Text('Chat'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryPurple,
                side: const BorderSide(color: AppTheme.primaryPurple),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<AppProvider>().navigateToScreen(AppScreen.calendar);
              },
              icon: const Icon(LucideIcons.calendar),
              label: const Text('Agendar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServices() {
    if (_venue!.services.isEmpty) {
      return const SizedBox.shrink();
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Serviços',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: _venue!.services.map((service) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.gray50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.gray200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.gray900,
                            ),
                          ),
                        ),
                        if (service.popular) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Popular',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (service.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        service.description,
                        style: const TextStyle(
                          color: AppTheme.gray600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'R\$ ${service.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        Text(
                          'Sinal: ${service.depositPercentage}%',
                          style: const TextStyle(
                            color: AppTheme.gray600,
                            fontSize: 12,
                          ),
                        ),
                      ],
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

  Widget _buildAbout() {
    if (_venue!.description?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

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
            'Sobre',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.gray900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _venue!.description!,
            style: const TextStyle(
              color: AppTheme.gray700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviews() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avaliações (${_reviews.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gray900,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppProvider>().navigateToScreen(AppScreen.reviews);
                },
                child: const Text(
                  'Ver todas',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_reviews.isEmpty)
            const Text(
              'Ainda não há avaliações para este profissional.',
              style: TextStyle(
                color: AppTheme.gray600,
              ),
            )
          else
            Column(
              children: _reviews.take(3).map((review) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: _buildReviewItem(review),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
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
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        LucideIcons.star,
                        size: 14,
                        color: index < review.rating
                            ? const Color(0xFFFACC15) // yellow-400
                            : AppTheme.gray300,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (review.comment?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Text(
            review.comment!,
            style: const TextStyle(
              color: AppTheme.gray700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.read<AppProvider>().navigateToScreen(AppScreen.calendar);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Reservar Agora',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}