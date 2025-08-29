import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:partyu/models/venue_model.dart';
import 'package:partyu/utils/app_theme.dart';

class VenueCard extends StatelessWidget {
  final Venue venue;
  final VoidCallback onTap;

  const VenueCard({super.key, required this.venue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppTheme.gray100,
                  child: venue.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: venue.images.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            LucideIcons.image,
                            color: AppTheme.gray400,
                            size: 32,
                          ),
                        )
                      : const Icon(
                          LucideIcons.image,
                          color: AppTheme.gray400,
                          size: 32,
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Category
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            venue.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            venue.category,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Description
                    if (venue.description?.isNotEmpty == true) ...[
                      Text(
                        venue.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Distance, Rating
                    Row(
                      children: [
                        // Rating
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.star,
                              size: 14,
                              color: Color(0xFFFACC15), // yellow-400
                            ),
                            const SizedBox(width: 2),
                            Text(
                              "${venue.rating.toStringAsFixed(1)} (400)",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        // Distance
                        if (venue.distance != null) ...[
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  LucideIcons.mapPin,
                                  size: 12,
                                  color: AppTheme.gray400,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    venue.distance!,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppTheme.gray500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        //const Spacer(),
                      ],
                    ),

                    //Price and Period
                    Row(
                      children: [
                        if (venue.price != null) ...[
                          const Icon(
                            LucideIcons.coins,
                            size: 14,
                            color: Color(0xFFFACC15),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            venue.price!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (venue.period != null) ...[
                            Text(
                              '/${venue.period}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.gray500),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                LucideIcons.chevronRight,
                color: AppTheme.gray400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
