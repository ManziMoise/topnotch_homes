import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/theme.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/property_card.dart';
import '../profile/profile_screen.dart';
import '../property/property_detail_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _propertyService = PropertyService();
  PropertyType? _selectedType;

  List<Property> get _filteredProperties {
    if (_selectedType == null) return _propertyService.getAllProperties();
    return _propertyService.searchProperties(type: _selectedType);
  }

  List<Property> get _featuredProperties =>
      _propertyService.getFeaturedProperties();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                'Topnotch Homes',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search bar
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: AppColors.textLight),
                            SizedBox(width: 12),
                            Text(
                              'Search by city, name, or location...',
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CategoryChip(
                            label: 'All',
                            icon: Icons.grid_view_rounded,
                            isSelected: _selectedType == null,
                            onTap: () => setState(() => _selectedType = null),
                          ),
                          const SizedBox(width: 10),
                          CategoryChip(
                            label: 'Budget',
                            icon: Icons.savings_outlined,
                            isSelected: _selectedType == PropertyType.budget,
                            onTap: () => setState(
                                () => _selectedType = PropertyType.budget),
                          ),
                          const SizedBox(width: 10),
                          CategoryChip(
                            label: 'Mid-Range',
                            icon: Icons.apartment_outlined,
                            isSelected: _selectedType == PropertyType.midrange,
                            onTap: () => setState(
                                () => _selectedType = PropertyType.midrange),
                          ),
                          const SizedBox(width: 10),
                          CategoryChip(
                            label: 'Luxury',
                            icon: Icons.villa_outlined,
                            isSelected: _selectedType == PropertyType.luxury,
                            onTap: () => setState(
                                () => _selectedType = PropertyType.luxury),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured section
            if (_selectedType == null) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Stays',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Icon(Icons.local_fire_department,
                          color: AppColors.accent),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _featuredProperties.length,
                    itemBuilder: (context, index) {
                      final property = _featuredProperties[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 280,
                          child: PropertyCard(
                            property: property,
                            onTap: () => _openDetail(property),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],

            // All / Filtered listings
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  _selectedType == null
                      ? 'Explore All'
                      : '${_selectedType!.name[0].toUpperCase()}${_selectedType!.name.substring(1)} Properties',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final property = _filteredProperties[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PropertyCard(
                        property: property,
                        onTap: () => _openDetail(property),
                      ),
                    );
                  },
                  childCount: _filteredProperties.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  void _openDetail(Property property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertyDetailScreen(property: property),
      ),
    );
  }
}
