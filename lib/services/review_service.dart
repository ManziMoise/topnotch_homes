import 'package:uuid/uuid.dart';

import '../models/review.dart';

class ReviewService {
  static final List<Review> _reviews = [
    Review(
      id: 'r1',
      propertyId: '1',
      guestName: 'Jean Pierre',
      rating: 5.0,
      comment: 'Amazing apartment with a great view of Kigali! Very clean and the host was super responsive. Will definitely book again.',
      createdAt: DateTime(2026, 2, 10),
    ),
    Review(
      id: 'r2',
      propertyId: '1',
      guestName: 'Sarah M.',
      rating: 4.0,
      comment: 'Good location, close to restaurants and shops. WiFi was a bit slow but otherwise a pleasant stay.',
      createdAt: DateTime(2026, 1, 25),
    ),
    Review(
      id: 'r3',
      propertyId: '2',
      guestName: 'David K.',
      rating: 5.0,
      comment: 'The villa is absolutely stunning. Lake Kivu views are breathtaking. The pool and private beach made it unforgettable.',
      createdAt: DateTime(2026, 3, 1),
    ),
    Review(
      id: 'r4',
      propertyId: '2',
      guestName: 'Claire N.',
      rating: 5.0,
      comment: 'Perfect for our family vacation. Kids loved the pool and the beach. Highly recommend for groups.',
      createdAt: DateTime(2026, 2, 20),
    ),
    Review(
      id: 'r5',
      propertyId: '3',
      guestName: 'Tom W.',
      rating: 4.0,
      comment: 'Great base for gorilla trekking. Simple but clean rooms. Breakfast was delicious with local food.',
      createdAt: DateTime(2026, 2, 15),
    ),
    Review(
      id: 'r6',
      propertyId: '6',
      guestName: 'Patricia A.',
      rating: 5.0,
      comment: 'Perfect for my business trip. The office space and concierge service were excellent. Very professional.',
      createdAt: DateTime(2026, 3, 5),
    ),
    Review(
      id: 'r7',
      propertyId: '8',
      guestName: 'Michael R.',
      rating: 5.0,
      comment: 'Waking up to the sounds of the forest was magical. The guided chimp trek was a highlight of our Rwanda trip.',
      createdAt: DateTime(2026, 2, 28),
    ),
  ];

  static const _uuid = Uuid();

  List<Review> getReviewsForProperty(String propertyId) {
    return _reviews
        .where((r) => r.propertyId == propertyId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  double getAverageRating(String propertyId) {
    final reviews = getReviewsForProperty(propertyId);
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
  }

  int getReviewCount(String propertyId) {
    return _reviews.where((r) => r.propertyId == propertyId).length;
  }

  Review addReview({
    required String propertyId,
    required String guestName,
    required double rating,
    required String comment,
  }) {
    final review = Review(
      id: _uuid.v4().substring(0, 8),
      propertyId: propertyId,
      guestName: guestName,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    _reviews.add(review);
    return review;
  }
}
