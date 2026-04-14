import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/theme.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';
import 'add_edit_property_screen.dart';
import 'property_bookings_screen.dart';

class ManagePropertiesScreen extends StatefulWidget {
  final bool canEdit;

  const ManagePropertiesScreen({super.key, this.canEdit = true});

  @override
  State<ManagePropertiesScreen> createState() => _ManagePropertiesScreenState();
}

class _ManagePropertiesScreenState extends State<ManagePropertiesScreen> {
  final _propertyService = PropertyService();

  @override
  Widget build(BuildContext context) {
    final properties = _propertyService.getAllProperties();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canEdit ? 'Manage Properties' : 'View Properties'),
        actions: [
          if (widget.canEdit)
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              onPressed: () => _openAddProperty(),
            ),
        ],
      ),
      floatingActionButton: widget.canEdit
          ? FloatingActionButton(
              onPressed: _openAddProperty,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: properties.isEmpty
          ? Center(
              child: Text(
                'No properties yet',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return _PropertyManageCard(
                  property: property,
                  canEdit: widget.canEdit,
                  onEdit: () => _openEditProperty(property),
                  onDelete: () => _confirmDelete(property),
                  onViewBookings: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PropertyBookingsScreen(
                        propertyId: property.id,
                        propertyTitle: property.title,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _openAddProperty() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditPropertyScreen()),
    );
    setState(() {});
  }

  void _openEditProperty(Property property) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditPropertyScreen(property: property),
      ),
    );
    setState(() {});
  }

  void _confirmDelete(Property property) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Property',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Are you sure you want to delete "${property.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _propertyService.deleteProperty(property.id);
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Property deleted')),
              );
            },
            child:
                const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _PropertyManageCard extends StatelessWidget {
  final Property property;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewBookings;

  const _PropertyManageCard({
    required this.property,
    this.canEdit = true,
    required this.onEdit,
    required this.onDelete,
    required this.onViewBookings,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (property.isVerified)
                        const Icon(Icons.verified,
                            size: 16, color: AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.location} | ${property.propertyTypeLabel}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${property.pricePerNight.toInt()}/night',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.list_alt, size: 20),
                  color: AppColors.accent,
                  onPressed: onViewBookings,
                  tooltip: 'View Bookings',
                ),
                if (canEdit) ...[
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    color: AppColors.primary,
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: AppColors.error,
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
