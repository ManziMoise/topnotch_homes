class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

const List<FaqItem> faqItems = [
  FaqItem(
    question: 'How do I book a property?',
    answer:
        'Browse properties on the home screen, tap on one you like, then tap "Book Now". '
        'Select your check-in and check-out dates, enter your details, and proceed to payment.',
  ),
  FaqItem(
    question: 'What payment methods are accepted?',
    answer:
        'We accept MTN Mobile Money, Airtel Money, and credit/debit cards (Visa, Mastercard). '
        'All payments are processed securely.',
  ),
  FaqItem(
    question: 'Can I cancel my booking?',
    answer:
        'Yes, you can cancel pending bookings from the "My Bookings" screen. '
        'Tap the "Cancel Booking" button on any pending booking. '
        'Confirmed bookings may be subject to a cancellation fee.',
  ),
  FaqItem(
    question: 'What are the property categories?',
    answer:
        'Properties are categorized into three tiers:\n'
        '- Bronze: Budget-friendly options\n'
        '- Silver: Mid-range with good amenities\n'
        '- Gold: Luxury properties with premium features',
  ),
  FaqItem(
    question: 'Is there a maximum stay limit?',
    answer:
        'Yes, each property has a maximum stay duration. The default is 10 nights, '
        'but individual properties may have different limits. '
        'You will see the maximum stay displayed on the booking form.',
  ),
  FaqItem(
    question: 'How do I become a host?',
    answer:
        'To list your property on Topnotch Homes, please contact our team at '
        'hosts@topnotch.rw. We will verify your property and create a host account for you.',
  ),
  FaqItem(
    question: 'Are properties verified?',
    answer:
        'Properties with a blue verified badge have been physically inspected by our team '
        'to ensure quality, safety, and accuracy of the listing.',
  ),
  FaqItem(
    question: 'How do I leave a review?',
    answer:
        'Go to any property detail page and scroll down to the Reviews section. '
        'Tap "Write a Review" to share your experience with a rating and comment.',
  ),
  FaqItem(
    question: 'What service fee is charged?',
    answer:
        'A 4% service fee is added to each booking to cover platform operations, '
        'customer support, and payment processing.',
  ),
  FaqItem(
    question: 'How do I contact support?',
    answer:
        'You can reach us at:\n'
        'Email: support@topnotch.rw\n'
        'Phone: +250 788 000 000\n'
        'We are available Monday to Saturday, 8am - 6pm.',
  ),
];
