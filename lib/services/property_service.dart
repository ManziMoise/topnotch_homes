import '../models/property.dart';

class PropertyService {
  // Mock data — will be replaced with Firestore later
  static final List<Property> _properties = [
    const Property(
      id: '1',
      title: 'Kigali Heights Apartment',
      description:
          'Modern 2-bedroom apartment in the heart of Kigali with stunning city views. '
          'Fully furnished with high-speed WiFi, perfect for business travelers and tourists alike. '
          'Walking distance to Kigali Convention Centre and top restaurants.',
      location: 'Kimihurura, Kigali',
      city: 'Kigali',
      imageUrls: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      ],
      pricePerNight: 65,
      propertyType: PropertyType.midrange,
      amenities: ['WiFi', 'Kitchen', 'Parking', 'AC', 'TV', 'Washer'],
      rating: 4.7,
      isVerified: true,
      isFeatured: true,
      latitude: -1.9536,
      longitude: 30.0926,
    ),
    const Property(
      id: '2',
      title: 'Lake Kivu Luxury Villa',
      description:
          'Breathtaking lakefront villa with private beach access on Lake Kivu. '
          'Features 4 bedrooms, infinity pool, and panoramic lake views. '
          'Ideal for family vacations and group retreats.',
      location: 'Rubavu, Western Province',
      city: 'Rubavu',
      imageUrls: [
        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
      ],
      pricePerNight: 180,
      propertyType: PropertyType.luxury,
      amenities: ['Pool', 'WiFi', 'Kitchen', 'Lake View', 'BBQ', 'Garden', 'Parking'],
      rating: 4.9,
      isVerified: true,
      isFeatured: true,
      latitude: -1.6813,
      longitude: 29.2387,
    ),
    const Property(
      id: '3',
      title: 'Musanze Budget Guesthouse',
      description:
          'Clean and comfortable guesthouse near Volcanoes National Park. '
          'Perfect base for gorilla trekking adventures. '
          'Friendly staff and local breakfast included.',
      location: 'Musanze, Northern Province',
      city: 'Musanze',
      imageUrls: [
        'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800',
        'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800',
      ],
      pricePerNight: 25,
      propertyType: PropertyType.budget,
      amenities: ['WiFi', 'Breakfast', 'Hot Water', 'Security'],
      rating: 4.3,
      isVerified: true,
      isFeatured: false,
      latitude: -1.4998,
      longitude: 29.6350,
    ),
    const Property(
      id: '4',
      title: 'Nyamata Boutique Home',
      description:
          'Charming boutique home with traditional Rwandan decor and modern comforts. '
          'Spacious rooms with garden views. Quiet neighborhood, '
          'great for those seeking a peaceful retreat.',
      location: 'Nyamata, Bugesera',
      city: 'Bugesera',
      imageUrls: [
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
        'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
      ],
      pricePerNight: 45,
      propertyType: PropertyType.midrange,
      amenities: ['WiFi', 'Garden', 'Kitchen', 'Parking', 'Laundry'],
      rating: 4.5,
      isVerified: true,
      isFeatured: true,
      latitude: -2.3628,
      longitude: 30.0875,
    ),
    const Property(
      id: '5',
      title: 'Huye City Hostel',
      description:
          'Affordable hostel in the university city of Huye. '
          'Dormitory and private rooms available. Common kitchen, '
          'lounge area, and friendly backpacker atmosphere.',
      location: 'Huye, Southern Province',
      city: 'Huye',
      imageUrls: [
        'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
        'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=800',
      ],
      pricePerNight: 15,
      propertyType: PropertyType.budget,
      amenities: ['WiFi', 'Kitchen', 'Lounge', 'Lockers'],
      rating: 4.1,
      isVerified: false,
      isFeatured: false,
      latitude: -2.5966,
      longitude: 29.7394,
    ),
    const Property(
      id: '6',
      title: 'Kigali Executive Suite',
      description:
          'Premium serviced apartment in Kigali\'s business district. '
          'Concierge service, daily housekeeping, and fully equipped office space. '
          'Perfect for corporate stays and NGO professionals.',
      location: 'Kacyiru, Kigali',
      city: 'Kigali',
      imageUrls: [
        'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=800',
        'https://images.unsplash.com/photo-1600573472550-8090b5e0745e?w=800',
        'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=800',
      ],
      pricePerNight: 120,
      propertyType: PropertyType.luxury,
      amenities: ['WiFi', 'Office', 'Concierge', 'Gym', 'AC', 'Parking', 'Housekeeping'],
      rating: 4.8,
      isVerified: true,
      isFeatured: true,
      latitude: -1.9403,
      longitude: 30.0587,
    ),
    const Property(
      id: '7',
      title: 'Gisenyi Beach Cottage',
      description:
          'Cozy cottage steps from the sandy shores of Lake Kivu in Gisenyi. '
          'Rustic charm with modern amenities. Watch spectacular sunsets from your private terrace.',
      location: 'Gisenyi, Rubavu',
      city: 'Rubavu',
      imageUrls: [
        'https://images.unsplash.com/photo-1587061949409-02df41d5e562?w=800',
        'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=800',
      ],
      pricePerNight: 55,
      propertyType: PropertyType.midrange,
      amenities: ['WiFi', 'Terrace', 'Lake View', 'Kitchen', 'BBQ'],
      rating: 4.6,
      isVerified: true,
      isFeatured: false,
      latitude: -1.6770,
      longitude: 29.2560,
    ),
    const Property(
      id: '8',
      title: 'Nyungwe Forest Lodge',
      description:
          'Exclusive eco-lodge at the edge of Nyungwe Forest National Park. '
          'Wake up to the sounds of chimpanzees and exotic birds. '
          'Guided forest walks and tea plantation tours available.',
      location: 'Nyungwe, Western Province',
      city: 'Rusizi',
      imageUrls: [
        'https://images.unsplash.com/photo-1618767689160-da3fb810aad7?w=800',
        'https://images.unsplash.com/photo-1596178065887-1198b6148b2b?w=800',
      ],
      pricePerNight: 200,
      propertyType: PropertyType.luxury,
      amenities: ['WiFi', 'Restaurant', 'Guided Tours', 'Spa', 'Garden', 'Fireplace'],
      rating: 4.9,
      isVerified: true,
      isFeatured: true,
      latitude: -2.4820,
      longitude: 29.2180,
    ),
  ];

  List<Property> getAllProperties() => List.unmodifiable(_properties);

  List<Property> getFeaturedProperties() =>
      _properties.where((p) => p.isFeatured).toList();

  Property? getPropertyById(String id) {
    try {
      return _properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Property> searchProperties({
    String? query,
    PropertyType? type,
    double? minPrice,
    double? maxPrice,
    String? city,
  }) {
    return _properties.where((p) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!p.title.toLowerCase().contains(q) &&
            !p.location.toLowerCase().contains(q) &&
            !p.city.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (type != null && p.propertyType != type) return false;
      if (minPrice != null && p.pricePerNight < minPrice) return false;
      if (maxPrice != null && p.pricePerNight > maxPrice) return false;
      if (city != null && city.isNotEmpty && p.city.toLowerCase() != city.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  List<String> getAvailableCities() {
    return _properties.map((p) => p.city).toSet().toList()..sort();
  }

  void addProperty(Property property) {
    _properties.add(property);
  }

  void updateProperty(Property updated) {
    final index = _properties.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _properties[index] = updated;
    }
  }

  void deleteProperty(String id) {
    _properties.removeWhere((p) => p.id == id);
  }

  int get totalCount => _properties.length;
}
