class Review {
  final String id;
  final String propertyId;
  final String guestName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.propertyId,
    required this.guestName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
