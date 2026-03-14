import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/theme.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import '../../widgets/property_card.dart';
import '../property/property_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _propertyService = PropertyService();
  final _searchController = TextEditingController();

  PropertyType? _selectedType;
  String? _selectedCity;
  RangeValues _priceRange = const RangeValues(0, 250);
  List<Property> _results = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _results = _propertyService.getAllProperties();
  }

  void _applyFilters() {
    setState(() {
      _hasSearched = true;
      _results = _propertyService.searchProperties(
        query: _searchController.text,
        type: _selectedType,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        city: _selectedCity,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cities = _propertyService.getAvailableCities();

    return Scaffold(
      appBar: AppBar(title: const Text('Search Properties')),
      body: Column(
        children: [
          // Search & filters
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _applyFilters(),
                  decoration: InputDecoration(
                    hintText: 'Search by name or location...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilters();
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 14),
                // Filter row
                Row(
                  children: [
                    // Property type dropdown
                    Expanded(
                      child: DropdownButtonFormField<PropertyType>(
                        initialValue: _selectedType,
                        hint: const Text('Type', style: TextStyle(fontSize: 14)),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Types'),
                          ),
                          ...PropertyType.values.map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name[0].toUpperCase() + t.name.substring(1)),
                              )),
                        ],
                        onChanged: (val) {
                          _selectedType = val;
                          _applyFilters();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // City dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCity,
                        hint: const Text('City', style: TextStyle(fontSize: 14)),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Cities'),
                          ),
                          ...cities.map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              )),
                        ],
                        onChanged: (val) {
                          _selectedCity = val;
                          _applyFilters();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Price range slider
                Row(
                  children: [
                    Text(
                      'Price: \$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 250,
                  divisions: 25,
                  activeColor: AppColors.primary,
                  labels: RangeLabels(
                    '\$${_priceRange.start.toInt()}',
                    '\$${_priceRange.end.toInt()}',
                  ),
                  onChanged: (values) {
                    setState(() => _priceRange = values);
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Text(
                  '${_results.length} ${_results.length == 1 ? 'property' : 'properties'} found',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Results list
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _hasSearched ? Icons.search_off : Icons.search,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _hasSearched
                              ? 'No properties match your filters'
                              : 'Start searching',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final property = _results[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: PropertyCard(
                          property: property,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PropertyDetailScreen(property: property),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
