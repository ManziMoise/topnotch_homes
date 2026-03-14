import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../config/theme.dart';
import '../../models/property.dart';
import '../../services/property_service.dart';

class AddEditPropertyScreen extends StatefulWidget {
  final Property? property;

  const AddEditPropertyScreen({super.key, this.property});

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _propertyService = PropertyService();

  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _locationController;
  late final TextEditingController _cityController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _amenitiesController;

  late PropertyType _propertyType;
  late bool _isVerified;
  late bool _isFeatured;

  bool get _isEditing => widget.property != null;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    _locationController = TextEditingController(text: p?.location ?? '');
    _cityController = TextEditingController(text: p?.city ?? '');
    _priceController = TextEditingController(
      text: p != null ? p.pricePerNight.toStringAsFixed(0) : '',
    );
    _imageUrlController = TextEditingController(
      text: p?.imageUrls.join('\n') ?? '',
    );
    _amenitiesController = TextEditingController(
      text: p?.amenities.join(', ') ?? '',
    );
    _propertyType = p?.propertyType ?? PropertyType.midrange;
    _isVerified = p?.isVerified ?? false;
    _isFeatured = p?.isFeatured ?? false;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final imageUrls = _imageUrlController.text
        .split('\n')
        .map((u) => u.trim())
        .where((u) => u.isNotEmpty)
        .toList();

    final amenities = _amenitiesController.text
        .split(',')
        .map((a) => a.trim())
        .where((a) => a.isNotEmpty)
        .toList();

    final property = Property(
      id: widget.property?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      location: _locationController.text.trim(),
      city: _cityController.text.trim(),
      imageUrls: imageUrls.isEmpty
          ? ['https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800']
          : imageUrls,
      pricePerNight: double.tryParse(_priceController.text.trim()) ?? 0,
      propertyType: _propertyType,
      amenities: amenities,
      rating: widget.property?.rating ?? 4.0,
      isVerified: _isVerified,
      isFeatured: _isFeatured,
    );

    if (_isEditing) {
      _propertyService.updateProperty(property);
    } else {
      _propertyService.addProperty(property);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing ? 'Property updated' : 'Property added'),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _amenitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Property' : 'Add Property'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Property Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (e.g. Kimihurura, Kigali)',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per Night (USD)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null) return 'Enter a number';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Property type dropdown
              _sectionLabel('Property Type'),
              const SizedBox(height: 8),
              DropdownButtonFormField<PropertyType>(
                initialValue: _propertyType,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category),
                ),
                items: PropertyType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(
                            t.name[0].toUpperCase() + t.name.substring(1),
                          ),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _propertyType = v);
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _amenitiesController,
                decoration: const InputDecoration(
                  labelText: 'Amenities (comma-separated)',
                  prefixIcon: Icon(Icons.checklist),
                  hintText: 'WiFi, Kitchen, Parking, AC',
                ),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URLs (one per line)',
                  prefixIcon: Icon(Icons.image),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 14),

              // Toggles
              SwitchListTile(
                title: Text('Verified', style: GoogleFonts.poppins()),
                subtitle: const Text('Mark as verified property'),
                value: _isVerified,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _isVerified = v),
              ),
              SwitchListTile(
                title: Text('Featured', style: GoogleFonts.poppins()),
                subtitle: const Text('Show in featured section'),
                value: _isFeatured,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _isFeatured = v),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Update Property' : 'Add Property'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );
  }
}
