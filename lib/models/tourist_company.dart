class TouristCompany {
  final String id;
  final String name;
  final String city;
  final String phone;
  final String? website;
  final List<String> services;

  const TouristCompany({
    required this.id,
    required this.name,
    required this.city,
    required this.phone,
    this.website,
    required this.services,
  });
}
