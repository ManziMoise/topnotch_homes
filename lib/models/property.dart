enum PropertyType { budget, midrange, luxury }

class Property {
  final String id;
  final String title;
  final String description;
  final String location;
  final String city;
  final List<String> imageUrls;
  final double pricePerNight;
  final PropertyType propertyType;
  final List<String> amenities;
  final double rating;
  final bool isVerified;
  final bool isFeatured;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.city,
    required this.imageUrls,
    required this.pricePerNight,
    required this.propertyType,
    required this.amenities,
    required this.rating,
    this.isVerified = false,
    this.isFeatured = false,
  });

  String get propertyTypeLabel {
    switch (propertyType) {
      case PropertyType.budget:
        return 'Budget';
      case PropertyType.midrange:
        return 'Mid-Range';
      case PropertyType.luxury:
        return 'Luxury';
    }
  }

  double get commissionRate {
    switch (propertyType) {
      case PropertyType.budget:
        return 0.12;
      case PropertyType.midrange:
        return 0.15;
      case PropertyType.luxury:
        return 0.18;
    }
  }
}
