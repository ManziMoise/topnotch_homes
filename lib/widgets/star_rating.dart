import 'package:flutter/material.dart';

import '../config/theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 24,
    this.interactive = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return GestureDetector(
          onTap: interactive ? () => onChanged?.call(starValue) : null,
          child: Icon(
            icon,
            size: size,
            color: AppColors.starYellow,
          ),
        );
      }),
    );
  }
}
