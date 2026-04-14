import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/theme.dart';
import '../../models/property.dart';
import '../../services/review_service.dart';
import '../../widgets/property_map_preview.dart';
import '../../widgets/review_card.dart';
import '../../widgets/star_rating.dart';
import '../booking/booking_form_screen.dart';
import 'activities_section.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _currentImageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image carousel
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: property.imageUrls.length,
                    onPageChanged: (i) =>
                        setState(() => _currentImageIndex = i),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: property.imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: AppColors.divider,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.divider,
                          child: const Icon(Icons.image, size: 48),
                        ),
                      );
                    },
                  ),
                  // Page indicators
                  if (property.imageUrls.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          property.imageUrls.length,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImageIndex == i ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == i
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge + verified
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          property.propertyTypeLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      if (property.isVerified) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.verified,
                            size: 20, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    property.title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location + Rating
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Icon(Icons.star,
                          size: 18, color: AppColors.starYellow),
                      const SizedBox(width: 4),
                      Text(
                        property.rating.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${property.pricePerNight.toInt()}',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          ' / night',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About this property',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Location map
                  if (property.hasCoordinates)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: PropertyMapPreview(
                        latitude: property.latitude!,
                        longitude: property.longitude!,
                        title: property.title,
                      ),
                    ),

                  // Amenities
                  Text(
                    'Amenities',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: property.amenities
                        .map((a) => _AmenityChip(amenity: a))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Activities
                  ActivitiesSection(city: property.city),

                  // Reviews section
                  _ReviewsSection(
                    propertyId: property.id,
                    onReviewAdded: () => setState(() {}),
                  ),

                  const SizedBox(height: 100), // space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Book Now button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingFormScreen(property: property),
                ),
              ),
              child: const Text('Book Now'),
            ),
          ),
        ),
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String amenity;

  const _AmenityChip({required this.amenity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconForAmenity, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            amenity,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  IconData get _iconForAmenity {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'kitchen':
        return Icons.kitchen;
      case 'parking':
        return Icons.local_parking;
      case 'ac':
        return Icons.ac_unit;
      case 'tv':
        return Icons.tv;
      case 'pool':
        return Icons.pool;
      case 'gym':
        return Icons.fitness_center;
      case 'washer':
        return Icons.local_laundry_service;
      case 'garden':
        return Icons.yard;
      case 'bbq':
        return Icons.outdoor_grill;
      case 'lake view':
        return Icons.water;
      case 'breakfast':
        return Icons.free_breakfast;
      case 'hot water':
        return Icons.hot_tub;
      case 'security':
        return Icons.security;
      case 'office':
        return Icons.work;
      case 'concierge':
        return Icons.room_service;
      case 'housekeeping':
        return Icons.cleaning_services;
      case 'terrace':
        return Icons.deck;
      case 'restaurant':
        return Icons.restaurant;
      case 'spa':
        return Icons.spa;
      case 'guided tours':
        return Icons.hiking;
      case 'fireplace':
        return Icons.fireplace;
      case 'lounge':
        return Icons.weekend;
      case 'lockers':
        return Icons.lock;
      case 'laundry':
        return Icons.local_laundry_service;
      default:
        return Icons.check_circle_outline;
    }
  }
}

class _ReviewsSection extends StatefulWidget {
  final String propertyId;
  final VoidCallback onReviewAdded;

  const _ReviewsSection({
    required this.propertyId,
    required this.onReviewAdded,
  });

  @override
  State<_ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<_ReviewsSection> {
  final _reviewService = ReviewService();
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final reviews = _reviewService.getReviewsForProperty(widget.propertyId);
    final avgRating = _reviewService.getAverageRating(widget.propertyId);
    final displayedReviews = _showAll ? reviews : reviews.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (reviews.isNotEmpty)
              Row(
                children: [
                  StarRating(rating: avgRating, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${avgRating.toStringAsFixed(1)} (${reviews.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Write review button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showWriteReviewDialog(context),
            icon: const Icon(Icons.rate_review_outlined, size: 18),
            label: const Text('Write a Review'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Reviews list
        if (reviews.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No reviews yet. Be the first!',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else ...[
          ...displayedReviews.map((r) => ReviewCard(review: r)),
          if (reviews.length > 3 && !_showAll)
            Center(
              child: TextButton(
                onPressed: () => setState(() => _showAll = true),
                child: Text(
                  'Show all ${reviews.length} reviews',
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  void _showWriteReviewDialog(BuildContext context) {
    double selectedRating = 5.0;
    final commentController = TextEditingController();
    final nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24, 24, 24,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Write a Review',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Rating
                  Text(
                    'Your Rating',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: StarRating(
                      rating: selectedRating,
                      size: 36,
                      interactive: true,
                      onChanged: (val) {
                        setModalState(() => selectedRating = val);
                      },
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Comment
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Your Review',
                      alignLabelWithHint: true,
                      hintText: 'Share your experience...',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.trim().isEmpty ||
                            commentController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        _reviewService.addReview(
                          propertyId: widget.propertyId,
                          guestName: nameController.text.trim(),
                          rating: selectedRating,
                          comment: commentController.text.trim(),
                        );
                        Navigator.pop(ctx);
                        setState(() {});
                        widget.onReviewAdded();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Review submitted!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: const Text('Submit Review'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
