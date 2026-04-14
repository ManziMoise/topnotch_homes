enum ActivityType {
  adventure,
  cultural,
  nature,
  water,
  wildlife,
}

class Activity {
  final String id;
  final String name;
  final String description;
  final ActivityType type;
  final String city;
  final double price;
  final String? imageUrl;
  final String? companyName;

  const Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.city,
    required this.price,
    this.imageUrl,
    this.companyName,
  });

  String get typeLabel {
    switch (type) {
      case ActivityType.adventure:
        return 'Adventure';
      case ActivityType.cultural:
        return 'Cultural';
      case ActivityType.nature:
        return 'Nature';
      case ActivityType.water:
        return 'Water';
      case ActivityType.wildlife:
        return 'Wildlife';
    }
  }
}
